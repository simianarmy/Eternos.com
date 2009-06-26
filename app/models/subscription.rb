class Subscription < ActiveRecord::Base
  belongs_to :account
  belongs_to :subscription_plan
  has_many :subscription_payments
  
  before_create :set_renewal_at
  before_destroy :destroy_gateway_record
  
  attr_accessor :creditcard, :address
  attr_reader :response
  
  # renewal_period is the number of months to bill at a time
  # default is 1
  validates_numericality_of :renewal_period, :only_integer => true, :greater_than => 0
  validate_on_create :card_storage
  
  Limits = {
    Proc.new {|account, plan| !plan.user_limit || plan.user_limit >= Account::Limits['user_limit'].call(account) } => 
      'User limit for new plan would be exceeded.  Please delete some users and try again.'
  }
  
  def plan=(plan)
    [:amount, :user_limit, :renewal_period].each do |f|
      self.send("#{f}=", plan.send(f))
    end
    self.subscription_plan = plan
    self.state = 'active' unless (plan.amount && plan.amount > 0 && plan.trial_period)
  end
  
  def trial_days
    (self.next_renewal_at.to_i - Time.now.to_i) / 86400
  end
  
  def amount_in_pennies
    (amount * 100).to_i
  end
  
  def store_card(creditcard, gw_options = {})
    # Clear out payment info if switching to CC from PayPal
    destroy_gateway_record(paypal) if paypal?
    
    @response = if billing_id.blank?
      gateway.store(creditcard, gw_options)
    else
      gateway.update(billing_id, creditcard, gw_options)
    end
    
    if @response.success?
      self.card_number = creditcard.display_number
      self.card_expiration = "%02d-%d" % [creditcard.expiry_date.month, creditcard.expiry_date.year]
      set_billing
    else
      errors.add_to_base(@response.message)
      false
    end
  end
  
  def charge
    if amount == 0 || (@response = gateway.purchase(amount_in_pennies, self.billing_id)).success?
      update_attributes(:next_renewal_at => self.next_renewal_at.advance(:months => self.renewal_period), :state => 'active')
      subscription_payments.create(:account => account, :amount => amount, :transaction_id => @response.authorization) unless amount == 0
      true
    else
      errors.add_to_base(@response.message)
      false
    end
  end
  
  def start_paypal(return_url, cancel_url)
    if (@response = paypal.setup_authorization(:return_url => return_url, :cancel_return_url => cancel_url, :description => AppConfig['app_name'])).success?
      paypal.redirect_url_for(@response.params['token'])
    else
      errors.add_to_base("PayPal Error: #{@response.message}")
      false
    end
  end
  
  def complete_paypal(token)
    if (@response = paypal.details_for(token)).success?
      if (@response = paypal.create_billing_agreement_for(token)).success?
        # Clear out payment info if switching to PayPal from CC
        destroy_gateway_record(cc) unless paypal?

        self.card_number = 'PayPal'
        self.card_expiration = 'N/A'
        set_billing
      else
        errors.add_to_base("PayPal Error: #{@response.message}")
        false
      end
    else
      errors.add_to_base("PayPal Error: #{@response.message}")
      false
    end
  end
  
  def needs_payment_info?
    self.card_number.blank? && self.subscription_plan.amount && self.subscription_plan.amount > 0
  end
  
  def self.find_expiring_trials(renew_at = 7.days.from_now)
    find(:all, :include => :account, :conditions => { :state => 'trial', :next_renewal_at => (renew_at.beginning_of_day .. renew_at.end_of_day) })
  end
  
  def self.find_due_trials(renew_at = Time.now)
    find(:all, :include => :account, :conditions => { :state => 'trial', :next_renewal_at => (renew_at.beginning_of_day .. renew_at.end_of_day) }).select {|s| !s.card_number.blank? }
  end
  
  def self.find_due(renew_at = Time.now)
    find(:all, :include => :account, :conditions => { :state => 'active', :next_renewal_at => (renew_at.beginning_of_day .. renew_at.end_of_day) })
  end
  
  def paypal?
    card_number == 'PayPal'
  end

  protected
  
    def set_billing
      self.billing_id = @response.token unless @response.token.blank?
      
      if new_record?
        if !next_renewal_at? || next_renewal_at < 1.day.from_now.at_midnight
          if subscription_plan.trial_period?
            self.next_renewal_at = Time.now.advance(:months => subscription_plan.trial_period)
          else
            charge_amount = subscription_plan.setup_amount? ? subscription_plan.setup_amount : amount
            if (@response = gateway.purchase(charge_amount * 100, billing_id)).success?
              subscription_payments.build(:account => account, :amount => charge_amount, :transaction_id => @response.authorization, :setup => subscription_plan.setup_amount?)
              self.state = 'active'
              self.next_renewal_at = Time.now.advance(:months => renewal_period)
            else
              errors.add_to_base(@response.message)
              return false
            end
          end
        end
      else
        if !next_renewal_at? || next_renewal_at < 1.day.from_now.at_midnight
          if (@response = gateway.purchase(amount_in_pennies, billing_id)).success?
            subscription_payments.create(:account => account, :amount => amount, :transaction_id => @response.authorization)
            self.state = 'active'
            self.next_renewal_at = Time.now.advance(:months => renewal_period)
        else
            errors.add_to_base(@response.message)
            return false
        end
      else
          self.state = 'active'
        end
        self.save
      end
    
      true
    end
    
    def set_renewal_at
      return if self.subscription_plan.nil? || self.next_renewal_at
      self.next_renewal_at = Time.now.advance(:months => self.renewal_period)
    end
    
    def validate_on_update
      return unless self.subscription_plan.updated?
      Limits.each do |rule, message|
        unless rule.call(self.account, self.subscription_plan)
          errors.add_to_base(message)
        end
      end
    end
    
    def gateway
      paypal? ? paypal : cc
    end
    
    def paypal
      @paypal ||=  ActiveMerchant::Billing::Base.gateway(:paypal_express_reference_nv).new(config_from_file('paypal.yml'))
    end
    
    def cc
      @cc ||= ActiveMerchant::Billing::Base.gateway(AppConfig['gateway']).new(config_from_file('gateway.yml'))
    end

    def destroy_gateway_record(gw = gateway)
      return if billing_id.blank?
      gw.unstore(billing_id)
      self.card_number = nil
      self.card_expiration = nil
      self.billing_id = nil
    end
    
    def card_storage
      self.store_card(@creditcard, :billing_address => @address.to_activemerchant) if @creditcard && @address && card_number.blank?
    end
    
    def config_from_file(file)
      YAML.load_file(File.join(RAILS_ROOT, 'config', file))[RAILS_ENV].symbolize_keys
    end
end

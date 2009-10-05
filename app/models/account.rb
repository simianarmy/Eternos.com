class Account < ActiveRecord::Base
  
  has_many :users, :dependent => :destroy
  has_one :subscription, :dependent => :destroy
  has_many :subscription_payments
  
  validate :valid_domain?
  validate_on_create :valid_user?
  validate_on_create :valid_plan?
  validate_on_update :valid_payment_info?
  validate_on_create :valid_subscription?
  
  attr_accessible :name, :domain, :user, :plan, :plan_start, :creditcard, :address
  attr_accessor :user, :plan, :plan_start, :creditcard, :address
  
  after_create :create_admin
  #after_create :send_welcome_email
  
  # Need better solution that soft_deletable...look for using default_scope in Rails 2.3
  acts_as_soft_deletable
  
  acts_as_authorizable
  acts_as_state_machine :initial => :login
  
  state :login
  state :joined
  state :paying
  state :invalid
  
  event :join do
    transitions :to => :joined, :from => :login
  end
  
  event :billing_update do
    transitions :to => :paying, :from => [:login, :joined]
  end
  
  event :expired do
    transitions :to => :invalid, :from => [:joined, :paying]
  end
  
  Limits = {
    'user_limit' => Proc.new {|a| a.users.count }
  }
  
  Limits.each do |name, meth|
    define_method("reached_#{name}?") do
      return false unless self.subscription
      self.subscription.send(name) && self.subscription.send(name) <= meth.call(self)
    end
  end
  
  def admin
    has_admins.first
  end
  
  def needs_payment_info?
    if new_record?
      AppConfig.require_payment_info_for_trials && @plan && @plan.amount && @plan.amount > 0
    else
      self.subscription.needs_payment_info?
    end
  end
  
  def using_domain?
    @plan && @plan.allow_subdomain
  end
  
  # Does the account qualify for a particular subscription plan
  # based on the plan's limits
  def qualifies_for?(plan)
    Subscription::Limits.keys.collect {|rule| rule.call(self, plan) }.all?
  end
  
  def active?
    self.subscription.next_renewal_at >= Time.now
  end
  
  def domain
    @domain ||= self.full_domain.blank? ? '' : self.full_domain.split('.').first
  end
  
  def domain=(domain)
    @domain = domain
    self.full_domain = "#{domain}.#{AppConfig.base_domain}"
  end
  
  protected
  
    def valid_domain?
      if using_domain?
        self.errors.add(:domain, 'is an invalid format') unless domain =~ /\A[a-zA-Z0-9]+\Z/
        conditions = new_record? ? ['full_domain = ?', self.full_domain] : ['full_domain = ? and id <> ?', self.full_domain, self.id]
        self.errors.add(:domain, 'is not available') if self.full_domain.blank? || self.class.count(:conditions => conditions) > 0
      end
    end
    
    # An account must have an associated user to be the administrator
    def valid_user?
      if !@user
        errors.add_to_base("Missing user information")
      elsif !@user.valid?
        @user.errors.full_messages.each do |err|
          errors.add_to_base(err)
        end
      end
    end
    
    # Validate credit card & address if necessary, but not until in proper state
    def valid_payment_info?
      return if login?
      
      if needs_payment_info?
        unless @creditcard && @creditcard.valid?
          errors.add_to_base("Invalid payment information")
        end
        
        unless @address && @address.valid?
          errors.add_to_base("Invalid address")
        end
      end
    end
    
    def valid_plan?
      errors.add_to_base("Invalid plan selected.") unless @plan
    end
    
    def valid_subscription?
      return if errors.any? # Don't bother with a subscription if there are errors already
      @call_count ||= 0
      @call_count += 1
      logger.debug "account.build_subscription # #{@call_count} in valid_subscription?"
      logger.debug "from #{caller(2).first}"
      self.build_subscription(:plan => @plan, :next_renewal_at => @plan_start, :creditcard => @creditcard, :address => @address)

      if !subscription.valid?
        errors.add_to_base("Error with payment: #{subscription.errors.full_messages.to_sentence}")
        return false
      end
    end
    
    def create_admin
      user.is_admin_for self
      user.account = self
      user.save
      join!
    end
    
    def send_welcome_email
      spawn do
        SubscriptionNotifier.deliver_welcome(self)
      end
    end
    
end

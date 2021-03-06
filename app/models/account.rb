class Account < ActiveRecord::Base

  has_many :users, :dependent => :destroy
  has_one :subscription, :dependent => :destroy
  has_many :subscription_payments
  
  accepts_nested_attributes_for :users
  
  # From saas subscription project - not using subdomains yet
  #validates_format_of :domain, :with => /\A[a-zA-Z][a-zA-Z0-9]*\Z/
  #validates_exclusion_of :domain, :in => %W( support blog www billing help api #{AppConfig['admin_subdomain']} ), :message => "The domain <strong>{{value}}</strong> is not available."
  
  #validate :valid_domain?
  validate_on_create :valid_user?
  validate_on_create :valid_plan?
  validate_on_create :valid_payment_info?
  validate_on_create :valid_subscription?
  
  attr_accessible :name, :domain, :user, :users_attributes, :plan, :plan_start, :creditcard, :address, :company_name, :phone_number
  attr_accessor :user, :plan, :plan_start, :creditcard, :address, :affiliate
  
  after_create :create_admin
  #after_create :send_welcome_email
  
  # Need better solution that acts_as_paranoid...look for using default_scope in Rails 2.3
  # Using soft-deletes for now
  
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
    'user_limit'        => Proc.new {|a| a.users.count },
    'disk_limit'        => Proc.new {|a| a.backup_sources.map(&:bytes_backed_up).sum },
    'backup_site_limit' => Proc.new {|a| a.backup_sources.count }
  }
  
  Limits.each do |name, meth|
    define_method("reached_#{name}?") do
      return false unless self.subscription
      self.subscription.send(name) && self.subscription.send(name) <= meth.call(self)
    end
  end

  # Site (subdomain) to ID lookup class
  class Site
    SubdomainMap = HashWithIndifferentAccess.new({
      'www'   => 0,
      'vault' => 1
    }).freeze
    
    def self.default_id
      SubdomainMap['www']
    end
    
    def self.id_from_subdomain(sub)
      SubdomainMap[sub] || default_id
    end
  end
    
  # Returns admin user Member object
  def admin
    has_admins.first
  end
  
  def needs_payment_info?
    if new_record?
      AppConfig.require_payment_info_for_trials && @plan && @plan.amount.to_f + @plan.setup_amount.to_f > 0
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
  
  def cancel
    touch(:deleted_at)
    expired!
  end
  
  protected
  
    def valid_domain?
      conditions = new_record? ? ['full_domain = ?', self.full_domain] : ['full_domain = ? and id <> ?', self.full_domain, self.id]
      self.errors.add(:domain, 'is not available') if self.full_domain.blank? || self.class.count(:conditions => conditions) > 0
    end
    
    # An account must have an associated user to be the administrator
    def valid_user?
      u = @user ? @user : users.first
      if !u || !u.valid?
        errors.add_to_base("Missing or invalid user information")
      end
    end
    
    # Validate credit card & address if necessary, but not until after login state
    def valid_payment_info?
      return if state.nil? || login?
      
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
      self.build_subscription(:plan => @plan, :next_renewal_at => @plan_start, :creditcard => @creditcard, :address => @address, :affiliate => @affiliate)
      if !subscription.valid?
        errors.add_to_base("Error with payment: #{subscription.errors.full_messages.to_sentence}")
        return false
      end
    end
    
    def create_admin
      self.user.is_admin_for self
      self.user.account = self
      self.user.save
      join!
    end
    
    def send_welcome_email
      spawn do
        SubscriptionNotifier.deliver_welcome(self)
      end
    end
    
end

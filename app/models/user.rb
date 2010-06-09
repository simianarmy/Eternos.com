# $Id$
require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :account
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation
  has_one :address_book, :dependent => :destroy
  has_one :profile, :dependent => :destroy
  has_many :comments
    
  # Authentication: AuthLogic
  acts_as_authentic do |c|
    c.validate_login_field = false
    c.login_field = :login
    c.logged_in_timeout = SESSION_DURATION_SECONDS
    c.validates_length_of_password_field_options :minimum => 6, :if => :require_password?
    c.validates_length_of_password_field_options = c.validates_length_of_password_field_options.merge(
      :message => 'Password is too short')
    
    # All this just to avoid email length errors - redundant if with the email format validation
    c.merge_validates_length_of_email_field_options :allow_nil => true, :within => 0..255
  end

  # Authorization
  acts_as_authorized_user
  acts_as_authorizable
  
  acts_as_tagger
  
  # Virtual attributes
  attr_accessor :invitation_required, :registration_required, :terms_of_service

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :first_name, :last_name, :email, 
    :password, :password_confirmation, :identity_url, :invitation_token, 
    :full_name, :terms_of_service, :facebook_id, :facebook_referrer
  
  # Validate first,last name
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  #validates_uniqueness_of   :email, :case_sensitive => false
  #validates_email           :email, :message => "Invalid email address"
  validates_acceptance_of :terms_of_service, :on => :create, :message => "Please accept the Terms of Service"
  
  with_options :if => :invitation_required? do |u|
    u.validates_presence_of     :invitation_id
    u.validates_uniqueness_of   :invitation_id, :if => :invitation_id
  end
  before_create :set_invitation_limit, :make_activation_code
  after_create :register_user_to_fb
  after_create :initialize_address_book
  
  acts_as_state_machine :initial => :pending
  
  state :passive
  state :pending
  state :live,  :enter => :do_activate
  state :suspended
  state :deleted, :enter => :do_delete
  
  event :register do
    transitions :from => :passive, :to => :pending, :guard => Proc.new {|u| !u.identity_url.blank? || !(u.crypted_password.blank? && u.password.blank?) }
  end
  
  event :activate do
    transitions :from => :pending, :to => :live
  end
  
  event :suspend do
    transitions :from => [:passive, :pending, :live], :to => :suspended
  end
  
  event :delete do
    transitions :from => [:passive, :pending, :live, :suspended], :to => :deleted
  end
  
  event :unsuspend do
    transitions :from => :suspended, :to => :live,  :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending, :guard => Proc.new {|u| !u.activation_code.blank? }
    transitions :from => :suspended, :to => :passive
  end
  
  alias_attribute :name, :full_name
  alias_attribute :facebook_id, :facebook_uid
  
  named_scope :by_name, lambda { |n|
    { :conditions => ["CONCAT_WS(' ', first_name, last_name) = ?", n] }
  }
  
  named_scope :active, :conditions => { 'users.state' => 'live' }
  named_scope :closed, :conditions => { 'users.state' => 'deleted' }
  
  #Member.active.find_all(&:has_backup_data?).size
  
  # Roles
  AdminRole         = 'Admin'
  MemberRole        = 'Member'
  GuestRole         = 'Guest'
 
  #find the user in the database, first by the facebook user id and if that fails through the email hash
  def self.find_by_fb_user(fb_user)
    find_by_facebook_uid(fb_user.uid) || User.find_by_email_hash(fb_user.email_hashes)
  end
  
  # We are going to connect this user object with a facebook id. 
  def link_fb_connect(fb_user_id)
    unless fb_user_id.nil?
      #check for existing account
      # UPDATE:
      # allow multiple accounts to use the same facebook id I guess - 
      # makes debugging a lot easier too
      existing_fb_user = find_by_facebook_uid(fb_user_id)
      
      #unlink the existing account
      unless existing_fb_user.nil?
        existing_fb_user.facebook_id = nil
        existing_fb_user.save(false)
      end
      #link the new one
      self.facebook_id = fb_user_id
      save(false)
    end
  end

  # The Facebook registers user method is going to send the users email hash and our account id to Facebook
  # We need this so Facebook can find friends on our local application even if they have not connect through connect
  # We hen use the email hash in the database to later identify a user from Facebook with a local user
  def register_user_to_fb
    if AppConfig.register_users_to_facebook
      users = {:email => email, :account_id => id}
      Facebooker::User.register([users])
      self.email_hash = Facebooker::User.hash_email(email)
      save(false)
    end
    true
  end
  
  def facebook_user?
    return !facebook_id.nil? && facebook_id > 0
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    spawn do
      SubscriptionNotifier.deliver_password_reset(self)
    end
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  # For Authlogic::Session::MagicStates 
  # When using email registration or whatever, we need a way to prevent user from 
  # getting logged in after being created until they complete the signup process.
  def confirmed?
    live?
  end
  
  def facebook_session_connect(session)
    session.connect(facebook_session_key, facebook_id, nil, facebook_secret_key)
  end
  
  def email_registration_required?
    self.registration_required.nil? ? AppConfig.email_registration_required : self.registration_required
  end
  
  def invitation_required?
    self.invitation_required.nil? ? AppConfig.invitation_required : self.invitation_required
  end
  
  def invitation_required=(required)
    self[:invitation_required] = required
  end
  
  def invitation_token
    invitation.token if invitation
  end
  
  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end
  
  def get_invitation_limit
    invitation_limit.nil? ? 0 : invitation_limit
  end
  
  def name
    [first_name, last_name].join(' ')
  end
  
  def full_name=(full)
    self.first_name, *rest = full.split(' ')
    self.last_name = rest.join(' ')
  end
  
  def full_name
    address_book ? address_book.full_name : name
  end
  
  def email=(email)
    self[:login] = self[:email] = email
  end
  
  def role
    read_attribute(:type)
  end
  
  #  methods for determining roles - subclasses can override
  def member?
    has_role_requirement? MemberRole
  end
  
  def guest?
    has_role_requirement? GuestRole
  end
  
  # Added to support saas subscription account-users model
  def admin
    self.is_admin_for?
  end
  
  # Upgrades user to Member role
  def make_member!
    make_role!(MemberRole)
  end
  
  # ---------------------------------------
  # The following code has been generated by role_requirement.
  # You may wish to modify it to suit your need

  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role_requirement?(role_in_question)
    role_in_question == role
    # @_list ||= self.roles.collect(&:name)
    #     return true if @_list.include?(AdminRole)
    #     (@_list.include?(role_in_question.to_s) )
  end
  # --------------------------------------
  
  protected
  
  def login_required?
    not guest?
  end
  
  def require_password?
    !guest? && !facebook_user? && (crypted_password.blank? || !password.blank?)
  end
  
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
  def do_delete
    self.deleted_at = Time.now.utc
  end
  
  def do_activate
    @activated = true
    self.activated_at = Time.now.utc
    self.deleted_at = self.activation_code = nil
    make_member! unless guest?

    if save
      create_member_associations
    end
  end
  
  def recently_activated?
    @activated
  end

  def initialize_address_book
    create_address_book(:first_name => first_name, :last_name => last_name) unless address_book
    true # Required in order for callback chain to continue
  end

  def send_activation_mail
    # Must spawn as thread or will crash in Passenger
    spawn(:method => :thread) do
      begin
        UserMailer.deliver_activation(self) 
      rescue
        logger.error "Unable to send member activation email! " + $!
      end
    end
  end
  
  # BULLSHIT RAILS
  def terms_accepted
    self.errors.add(:terms_of_service, "You must accept the Terms & Conditions") unless @terms_of_service
  end
  
  private
  
  def role=(role)
    self[:type] = role
  end 
  
  def make_role!(role)
    self.role = role
    save!
  end
  
  def set_invitation_limit
    self.invitation_limit = 5
  end
  
  def create_member_associations
    ActivityStream.find_or_create_by_user_id(self.id)
    Profile.find_or_create_by_user_id(self.id)
  end
  
end

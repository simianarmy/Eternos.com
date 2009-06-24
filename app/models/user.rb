# $Id$
require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :account
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation
  has_one :address_book, :dependent => :destroy
  has_many :comments
  has_many :backup_sources, :dependent => :destroy
  
  # Authentication: AuthLogic
  acts_as_authentic do |c|
    c.validate_login_field = false
    c.login_field = :login
    c.logged_in_timeout = 30.minutes
    c.validates_length_of_password_field_options :minimum => 6, :if => :require_password?
    c.validates_length_of_email_field_options :minimum => 0 # to fix missing I18n error key problem
  end
  # Authorization
  acts_as_authorized_user
  acts_as_authorizable
  
  # Virtual attributes
  attr_accessor :invitation_required, :registration_required
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :first_name, :last_name, :email, :facebook_id,
    :password, :password_confirmation, :identity_url, :invitation_token, :terms_of_service
  
  # Validate first,last name
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  #validates_uniqueness_of   :email, :case_sensitive => false
  #validates_email           :email, :message => "Invalid email address"
  validates_acceptance_of :terms_of_service
  
  with_options :if => :invitation_required? do |u|
    u.validates_presence_of     :invitation_id
    u.validates_uniqueness_of   :invitation_id
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
  
  # Roles
  AdminRole         = 'Admin'
  MemberRole        = 'Member'
  GuestRole         = 'Guest'
  
  def backup_site_names
    rv = []
    backup_sources.each do |backup|
      rv << backup.backup_site.name.to_s
    end
    rv
  end
  # We are going to connect this user object with a facebook id. But only ever one account.
  def link_fb_connect(fb_user_id)
    unless fb_user_id.nil?
      #check for existing account
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
    users = {:email => email, :account_id => id}
    Facebooker::User.register([users])
    self.email_hash = Facebooker::User.hash_email(email)
    save(false)
  end
  
  def facebook_user?
    return !facebook_id.nil? && facebook_id > 0
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
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
      spawn do
        UserMailer.deliver_activation(self) 
      end
    end
  end
  
  def recently_activated?
    @activated
  end
  
  def initialize_address_book
    create_address_book(:first_name => first_name, :last_name => last_name) unless address_book
    true # Required in order for callback chain to continue
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
  
end

# $Id$

class GuestInvitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'Member'
  belongs_to :circle
  has_one :address, :as => :addressable, :dependent => :destroy, :validate => false
  has_many :phone_numbers, :as => :phoneable, :dependent => :destroy, :validate => false
  
  acts_as_time_locked
  include Addressable
  
  attr_accessible :name, :contact_method, :email, :new_phone_number_attributes, 
    :new_time_lock_attributes, :circle_id, :emergency_contact, :address_attributes,
    :time_lock_attributes, :existing_phone_number_attributes
  
  validates_presence_of :sender
  validates_presence_of :circle
  validates_presence_of :contact_method
  validates_presence_of :name
  validate :validate_contact_info
  
  # Should these be moved into an Observer?
  after_update :reset_delivery_status
  after_create :set_delivery_status
  after_update :save_associations
  
  acts_as_state_machine :initial => :created, :column => 'status'
  
  state :created
  state :pending
  state :waiting
  state :dormant
  state :support_processing
  state :accepted
  
  event :queue_for_delivery do
    transitions :from => [:created, :dormant], :to => :pending
  end
  
  event :send do
    transitions :from => :pending, :to => :waiting
  end
  
  event :hold do
    transitions :from => [:created, :pending], :to => :dormant
  end
  
  event :requires_support do
    transitions :from => [:created, :waiting, :dormant], :to => :support_processing
  end
  
  event :accept do
    transitions :from => :processing, :to => :accepted
    transitions :from => :support_processing, :to => :accepted
  end
  
  named_scope :unconfirmed, :conditions => ['status != ?', 'accepted']
  
  def contact_method
    self[:contact_method] ||= 'email'
  end
  
  def contact_by_email?; contact_method == 'email' end
  def contact_by_phone?; contact_method == 'phone' end
  def contact_by_mail?;  contact_method == 'mail'  end
  
  private 
  
  # Determines if it is time to send the invitation
  def can_send?
    # time_lock may have been deleted within callback chain - check if frozen
    (time_lock && !time_lock.frozen?) ? time_lock.expired? : true
  end
  
  # Sets invitation state to reflect current delivery conditions
  # on create
  def set_delivery_status
    can_send? ? queue_for_delivery! : hold!
    true
  end
  
  # on update
  def reset_delivery_status
    set_delivery_status if time_lock_changed?
    true
  end
  
  # Save all associations - lame but necessary
  def save_associations
    phone_numbers.map(&:save)
    address.save if address
    #time_lock.save if time_lock && !time_lock.frozen?
    true
  end
  
  # Always validate contact information.  Guest requires at least one contact method
  # (email, phone #, address)
  def validate_contact_info  
    case contact_method
    when 'email'
      errors.add(:email, "Invalid email address") unless EmailVeracity::Address.new(email).valid?
    when 'phone'
      if phone_numbers.empty?
        errors.add(:phone_number, "Please enter a phone number")
      else 
        phone_numbers.each do |pn|
          errors.add_to_base(pn.errors.full_messages) if pn && !pn.valid?
        end
      end
    when 'mail'
      if address.nil?
        errors.add(:address, "Please fill in mailing address")
      else
        errors.add_to_base(address.errors.full_messages) unless address.valid?
      end
    end
  end  
end

class InvitationDeliveryStatusWatcher
end
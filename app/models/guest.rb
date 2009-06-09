# $Id$
class Guest < User
  has_many :relationships
  has_many :hosts, :through => :relationships, :source => :member, :foreign_key => 'user_id', :uniq => true
  has_many :circles, :through => :relationships
  
  # Virtual attributes
  attr_accessor :current_host_id, :circle, :emergency_contact, :contact_method
  
  # Attributes that can be set through mass-assignment
  attr_accessible :circle_id
  
  after_create :add_to_host
  
  # Uses authorization plugin dynamic role methods to find host
  # Takes optional host id parameter in case guest has many hosts
  def get_host(host_id = self.current_host_id)
    if host_id
      self.is_guest_of_what.find {|host| host.id == host_id}
    else
      self.is_guest_of_what.first
    end
  end
  
  # A guest can only belong to one circle at a time, based on selected host
  def current_circle(host_id = self.current_host_id)
    if host_id and (rel = relationships.find_by_user_id(host_id))
      rel.circle
    else
      circles.first
    end
  end
      
  def relationship(host = get_host)
    relationships.find_by_user_id(host.id) if host
  end
  
  def can?(action, item)
    perms = PrivacySetting.find(:first, :conditions => 
      ['authorizable_id => ? AND authorizable_type = ? AND (user_id = ? OR circle_id = ?)',
      item.id, item.class.to_s, read_attribute(:id), circle.id])
    if !perms.nil?
      perms.action_allowed?(action)
    else
      false
    end
  end
  
  def guest?
    true
  end
  
  # Returns true if guest is an emergency contact for some member
  def emergency_contact_for?(host)
    self.is_emergency_contact_for? host
  end
  
  # Returns guest's invite sender
  def inviter
    invite = Invitation.find_by_recipient_email(login)
    User.find(invite.sender_id) unless invite.nil?
  end 
  
  # Form mass-assignment methods
  #
  
  # Updates relationship to current host
  def circle_id=(id)
    rel = relationship
    if rel && (rel.circle.id != id.to_i)
      rel.circle = Circle.find(id)
      rel.save
    end
  end
  
  # Attribute that controls if guest gets invitation email after creation or not
  def invite_now=(yesno)
    @send_contact_verification = yesno
  end
  
  private
  
  # Validation
  #
  # Only validate relationship & host on create
  def validate_on_create
    errors.add(:circle, "Invalid relationship") unless @circle && @circle.valid?
    errors.add(:host, "Could not determine the guest host") unless self.current_host_id
  end
  
  # Callbacks
  #
  
  # Prepare virtual attributes that observers will read to determine what 
  # if any emails need to be sent
  def set_invitation_flags
    self.invitation_required = false
    true
  end
    
  # Add self to host's guest list after create (circle will belong to host)
  def add_to_host
    raise "Unknown guest host!  You must set current_host_id before creating" unless current_host_id > 0
    user = User.find(current_host_id) # Raise error if not found
    user.add_guest(self, @circle)
    self.is_emergency_contact_for(user) if @emergency_contact
    true
  end
end

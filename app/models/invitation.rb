# $Id$
class Invitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  
  validates_email :recipient_email, :message => "Invalid email address"
  validate :recipient_is_not_registered
  validate :sender_has_invitations, :if => :sender
  
  before_create :generate_token
  before_create :decrement_sender_count, :if => :sender
  
  private
  
  def recipient_is_not_registered
    errors.add(:recipient_email, "Email owner is already a member") if User.find_by_email(recipient_email)
  end
  
  def sender_has_invitations
    unless sender.invitation_limit > 0
      errors.add_to_base 'You have reached your limit of invitations to send.'
    end
  end
  
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
    true
  end
  
  def decrement_sender_count
    sender.decrement! :invitation_limit
    true
  end
end

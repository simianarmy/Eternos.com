# $Id$

require 'guid'

class Trustee < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :name, :message => "Please enter trustee\'s full name"
  validates_presence_of :relationship, :message => "Please describe your relationship to the trustee (ie. brother, father)"
  validates_presence_of :security_question, :message => "Please enter the identity-verification question"
  validates_presence_of :security_answer, :message => "Please enter the identity-verification answer"
  validate :validate_emails
  
  serialize :emails
  
  after_create :send_confirmation_request
  
  acts_as_state_machine :initial => :created
  state :created
  state :pending_trustee_confirmation
  state :pending_user_confirmation
  state :confirmed
  state :rejected
  
  event :sent_confirmation_request do
    transitions :from => :created, :to => :pending_trustee_confirmation
  end
  
  event :confirmation_answered do
    transitions :from => :pending_trustee_confirmation, :to => :pending_user_confirmation
  end
  
  event :approved do
    transitions :from => :pending_user_confirmation, :to => :confirmed
  end
  
  event :denied do
    transitions :from => [:pending_user_confirmation, :confirmed], :to => :rejected
  end
  
  named_scope :confirmed, :conditions => {:state => 'confirmed'}
  named_scope :pending, :conditions => {
      :state => [:pending_trustee_confirmation, :pending_user_confirmation]
    }
    
  def emails=(vals)
    list = vals.split("\n").reject{|e| e.blank?}.map(&:strip)
    write_attribute(:emails, list)
  end
  
  def validate_emails
    unless emails.any?
      errors.add(:emails, "Please enter at least one contact email")
    else
      emails.each do |e|
        e.strip!
        unless e.blank? || EmailVeracity::Address.new(e).valid?
          errors.add(:emails, "'#{e}' is not a valid email address")
        end
      end
    end
  end
  
  def verified?
    self.state && confirmed?
  end
  
  protected
  
  def send_confirmation_request
    # Generate security code to put in email
    write_attribute(:security_code, generate_security_code)
    spawn { TrusteeMailer.deliver_confirmation_request(user, emails) }
    sent_confirmation_request!
  end
  
  def generate_security_code
    Guid.new.to_s
  end
end

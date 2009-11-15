# $Id$

require 'guid'

class Trustee < ActiveRecord::Base
  @@max_emails = 5
  cattr_reader :max_emails
  
  belongs_to :user
  
  validates_presence_of :name, :message => "Please enter trustee\'s full name"
  validates_presence_of :relationship, :message => "Please describe your relationship to the trustee (ie. brother, father)"
  validates_presence_of :security_question, :message => "Please enter the identity-verification question"
  validate :validate_emails
  
  serialize :emails
  
  # Virtual attributes
  attr_accessor :personal_note
  
  after_create :send_confirmation_request
  
  acts_as_state_machine :initial => :created
  state :created
  state :pending_trustee_confirmation
  state :pending_user_confirmation, :enter => :send_user_confirmation_request
  state :confirmed, :enter => :send_confirmation_approval
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
    if emails.empty?
      errors.add(:emails, "Please enter at least one contact email")
    elsif emails.length > max_emails
      errors.add(:emails, "There is a maximum of #{max_emails} email addresses")
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
    spawn { 
      TrusteeMailer.deliver_confirmation_request(user, self) 
    }
    sent_confirmation_request!
  end
  
  def send_user_confirmation_request
    spawn { 
      TrusteeMailer.deliver_user_confirmation_request(user, self) 
    }
  end
  
  def send_confirmation_approval
    spawn { 
      TrusteeMailer.deliver_confirmation_approved(user, self)
    }
  end
  
  def generate_security_code
    Guid.new.to_s
  end
end

# $Id$

require 'email_veracity'

class NotifyEmail < ActiveRecord::Base
  validates_uniqueness_of   :email, :case_sensitive => false, :message => "Email already saved"
  validates_presence_of     :email, :message => "Missing email address"
  
  protected
  
  def validate
    address = EmailVeracity::Address.new(self.email)
    errors.add(:email, address.errors.first.to_s) unless address.valid?
  end
end

class NotifyEmail < ActiveRecord::Base
  validates_uniqueness_of   :email, :case_sensitive => false, :message => "Email already saved"
  validates_email           :email, :message => "Invalid email address"
end

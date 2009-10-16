class Trustee < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :name, :message => "Please enter trustee\'s full name"
  validates_presence_of :relationship, :message => "Please describe your relationship to the trustee (ie. brother, father)"
  validate :validate_emails
  
  def validate_emails
    email_list = emails.split("\n")
    unless email_list.any?
      errors.add(:emails, "Please enter at least one contact email")
    else
      email_list.each do |e|
        unless EmailVeracity::Address.new(e).valid?
          errors.add(:emails, "'#{e}' is not a valid email address")
        end
      end
    end
  end
end

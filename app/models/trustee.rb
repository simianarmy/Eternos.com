class Trustee < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :name, :message => "Please enter trustee\'s full name"
  validates_presence_of :relationship, :message => "Please describe your relationship to the trustee (ie. brother, father)"
  validate :validate_emails
  
  serialize :emails
  
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
end

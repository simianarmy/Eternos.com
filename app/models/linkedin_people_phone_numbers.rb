class LinkedinPeoplePhoneNumbers < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_phone_numbers(phone_number)
  if phone_number.nil?
	return nil
  end
    li = self.new(phone_number)

    li
  end
end

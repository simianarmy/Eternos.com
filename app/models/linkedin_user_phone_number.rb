class LinkedinUserPhoneNumber < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"



  def self.from_phone_numbers(phone_number)
    if phone_number.nil?
      return nil
    end
    li = self.new(phone_number)

    li
  end
  def self.update_phone_numbers(phone_number,user_id)
    if phone_number.nil?
      return nil
    end


    li = self.find_all_by_linkedin_user_id(user_id).first
    li.update_attributes(phone_number)
    li.save
  end
end

class LinkedinUserPhoneNumber < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"



  def self.from_phone_numbers(phone_number)
    if phone_number.nil?
      return nil
    end
    li = self.new(phone_number)

    li
  end
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end
end

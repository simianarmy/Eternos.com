class LinkedinPeopleImAccount < ActiveRecord::Base

  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_im_account(im_account)
  if im_account.nil?
	return nil
  end
    li = self.new(im_account)
    li
  end
end

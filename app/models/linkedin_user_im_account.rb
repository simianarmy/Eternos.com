class LinkedinUserImAccount < ActiveRecord::Base

  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"

  def self.from_im_account(im_account)
    if im_account.nil?
      return nil
    end
    li = self.new(im_account)
    li
  end
  def self.update_im_accounts(im_account,user_id)
    if im_account.nil?
      return nil
    end

   
    li = self.find_all_by_linkedin_user_id(user_id).first
    li.update_attributes(im_account)
    li.save
  end
end

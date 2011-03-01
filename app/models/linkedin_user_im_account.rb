class LinkedinUserImAccount < ActiveRecord::Base

  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"

  def self.from_im_account(im_account)
    if im_account.nil?
      return nil
    end
    li = self.new(im_account)
    li
  end
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end
end

class LinkedinUserTwitterAccount < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
   
  def self.from_twitter_accounts(twitter_account)
    if twitter_account.nil?
      return nil
    end
    li = self.new(twitter_account)
   
    li
  end
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end
end

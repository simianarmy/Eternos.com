class LinkedinPeopleTwitterAccount < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_twitter_accounts(twitter_account)
  if twitter_account.nil?
	return nil
  end
    li = self.new(twitter_account)
   
    li
  end
end

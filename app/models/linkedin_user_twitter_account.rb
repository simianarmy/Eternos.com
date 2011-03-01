class LinkedinUserTwitterAccount < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
   
  def self.from_twitter_accounts(twitter_account)
    if twitter_account.nil?
      return nil
    end
    li = self.new(twitter_account)
   
    li
  end
  def self.update_twitter_accounts(twitter_account,user_id)
    if twitter_account.nil?
      return nil
    end

    RAILS_DEFAULT_LOGGER.info "\n #{twitter_account.inspect} \n"
    li = self.find_all_by_provider_account_id_and_linkedin_user_id(twitter_account['provider_account_id'],user_id).first
    li.update_attributes(twitter_account)
    li.save
  end
end

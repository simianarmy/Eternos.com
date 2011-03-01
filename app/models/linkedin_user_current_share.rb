class LinkedinUserCurrentShare < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
   def self.process_hash(current_share)
    if (current_share.nil?)
      return nil
    end
    current_share['linkedin_id'] = current_share['author']['id']
    current_share['first_name'] = current_share['author']['first_name']
    current_share['last_name'] = current_share['author']['last_name']
    current_share.delete('author')

    current_share['source'] = current_share.delete('source')['service_provider']['name']
    current_share['visibility'] = current_share.delete('visibility')['code']
	current_share['current_share_id'] = current_share.delete('id')
    current_share.delete('content')

    return current_share
  end
  def self.from_current_share(current_share)
    li = self.process_hash(current_share)
    li = self.new(current_share)
    li
  end
  def self.update_current_shares(current_share,user_id)
    if current_share.nil?
      return nil
    end

    current_share = self.process_hash(current_share)
	RAILS_DEFAULT_LOGGER.info "AAAAAAAAAAAAAAAAAA:\n #{current_share.inspect}"
    li = self.find_all_by_linkedin_user_id(user_id).first
    li.update_attributes(current_share)
    li.save
  end
end

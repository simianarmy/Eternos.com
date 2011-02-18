class LinkedinPeopleCurrentShare < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_current_share(current_share)
    current_share['linkedin_id'] = current_share['author']['id']
    current_share['first_name'] = current_share['author']['first_name']
    current_share['last_name'] = current_share['author']['last_name']
    current_share.delete('author')

    current_share['source'] = current_share.delete('source')['service_provider']['name']
    current_share['visibility'] = current_share.delete('visibility')['code']
	current_share.delete('content')
    li = self.new(current_share)
    li
  end
end

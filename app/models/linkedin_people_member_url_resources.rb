class LinkedinPeopleMemberUrlResources < ActiveRecord::Base
    belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"
    def self.from_member_urls(member_url_resources)
	if member_url_resources.nil?
		return nil
	end
    li = self.new(member_url_resources)
    li
  end
end

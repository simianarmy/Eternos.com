class LinkedinPeopleUpdateComment < ActiveRecord::Base
belongs_to :linkedin_people_comment_like,:foreign_key => "linkedin_people_comment_like_id"
 def self.from_comments(comment)
    comment['linkedin_id'] = comment['person']['id']
	comment['first_name'] = comment['person']['first_name']
	comment['last_name'] = comment['person']['last_name']
	comment['headline'] = comment['person']['headline']
	comment['api_standard_profile_request'] = comment['person']['api_standard_profile_request']['url']
	comment['id'] = comment['person']['id']
	comment['site_standard_profile_request'] = comment['person']['site_standard_profile_request']['url']
	comment.delete('person')
    li = self.new(comment)
    li
  end
end

class LinkedinPeopleUpdateLikes < ActiveRecord::Base
 belongs_to :linkedin_people_comment_like,:foreign_key => "linkedin_people_comment_like_id"
 def self.from_likes(like)
    
    li = self.new(like)
    li
  end
end

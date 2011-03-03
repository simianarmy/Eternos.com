class LinkedinUserUpdateLike < ActiveRecord::Base
  belongs_to :linkedin_user_comment_like,:foreign_key => "linkedin_user_comment_like_id"
  def self.process_hash(like)
    if (like.nil?)
      return nil
    end
	like['linkedin_id'] = like.delete('id')
   
    return like
  end
  def self.from_likes(like)
    self.process_hash(like)
    li = self.new(like)
    li
  end
  def self.update_likes(like,linkedin_user_comment_like_id)
    if (like.nil?)
      return nil
    end
    self.process_hash(like)
    li = self.find_all_by_linkedin_id_and_linkedin_user_comment_like_id(like['linkedin_id'],linkedin_user_comment_like_id).first
    li.update_attributes(like)
    li.save
  end
end

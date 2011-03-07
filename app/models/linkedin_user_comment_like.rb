class LinkedinUserCommentLike < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  has_many 	 :linkedin_user_update_likes, :class_name  => "LinkedinUserUpdateLike"
  has_many 	 :linkedin_user_update_comments, :class_name  => "LinkedinUserUpdateComment"
  def add_likes_from_comment_likes(likes)
    if likes.nil? || likes['like'].nil?
      return
    end
    if Integer(likes['total']) > 1
      likes['like'].each { |like|
        li = LinkedinUserUpdateLike.from_likes(like['person'])
        linkedin_user_update_likes << li
      }
    else
      li  = LinkedinUserUpdateLike.from_likes(likes['like']['person'])
      linkedin_user_update_likes << li
    end
  end
  
  def add_comments_from_comment_likes(comments)
    if comments.nil? || comments['update_comment'].nil?
      return
    end
    if Integer(comments['total']) > 1
      comments['update_comment'].each { |update_comment|
        li = LinkedinUserUpdateComment.from_comments(update_comment)
        linkedin_user_update_comments << li
      }
    else
      li  = LinkedinUserUpdateComment.from_comments(comments['update_comment'])
      linkedin_user_update_comments << li
    end
  end

  def self.process_hash(comment_like)
    if (comment_like.nil?)
      return nil
    end

    comment_like['linkedin_id'] = comment_like['update_content']['person']['id']
    comment_like['first_name'] = comment_like['update_content']['person']['first_name']
    comment_like['last_name'] = comment_like['update_content']['person']['last_name']
    comment_like['site_standard_profile_request'] = comment_like['update_content']['person']['site_standard_profile_request']['url']
    comment_like['headline'] = comment_like['update_content']['person']['headline']
    comment_like['current_status'] = comment_like['update_content']['person']['current_status']
    comment_like['api_standard_profile_request'] = comment_like['update_content']['person']['api_standard_profile_request']['url']
    comment_like.delete('update_content')
    comment_like['timestamp'] = Time.at(Integer( comment_like.delete('timestamp')) / 1000)
    return comment_like
  end
  
  def self.from_comment_likes(comment_like)
    if comment_like.nil?
      return nil
    end
    update_comments = comment_like.delete('update_comments')
    likes = comment_like.delete('likes')
    comment_like = self.process_hash(comment_like)
    li = self.new(comment_like)
		li.add_likes_from_comment_likes(likes)
		li.add_comments_from_comment_likes(update_comments)
    li
  end

  def self.update_comment_likes(comment_like,user_id)
    if comment_like.nil?
      return nil
    end
    update_comments = comment_like.delete('update_comments')
    likes = comment_like.delete('likes')
    comment_like = self.process_hash(comment_like)

    li = self.find_all_by_linkedin_user_id(user_id).first
    li.update_attributes(comment_like)
    li.save
    
		li_comment = LinkedinUserUpdateComment.find_all_by_linkedin_user_comment_like_id(li.id).first
		li_comment.update_attributes(update_comments)
    li_comment.save

    li_like = LinkedinUserUpdateLike.find_all_by_linkedin_user_comment_like_id(li.id).first
    li_like.update_attributes(likes)
    li_like.save
    
  end

end

class LinkedinUserCommentLike < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  has_many 	 :linkedin_user_update_likes
  has_many 	 :linkedin_user_update_comments
  def add_likes_from_comment_likes(likes)
    if likes.nil? || likes['like'].nil?
      return
    end
    
    if Integer(likes['total']) > 1
      likes['like'].each { |like|
        li = linkedin_user_update_likes.new(like['person'])
        linkedin_user_update_likes << li
      }
    else
	  li  = linkedin_user_update_likes.new(likes['like']['person'])
      linkedin_user_update_likes << li
    end
  end
  
  def add_comments_from_comment_likes(comments)
    if comments.nil? || comments['update_comment'].nil?
      return
    end
    if Integer(comments['total']) > 1
      comments['update_comment'].each { |update_comment|
        li = linkedin_user_update_comments.new(update_comment)
        linkedin_user_update_comments << li
      }
    else
      li  = linkedin_user_update_comments.new(comments['update_comment'])
      linkedin_user_update_comments << li
    end
  end

  def process_hash(comment_like)
    if (comment_like.nil?)
      return nil
    end
    result = Hash.new
    comment_like['linkedin_id'] = comment_like['update_content']['person']['id']
    comment_like['first_name'] = comment_like['update_content']['person']['first_name']
    comment_like['last_name'] = comment_like['update_content']['person']['last_name']
    comment_like['site_standard_profile_request'] = comment_like['update_content']['person']['site_standard_profile_request']['url']
    comment_like['headline'] = comment_like['update_content']['person']['headline']
    comment_like['current_status'] = comment_like['update_content']['person']['current_status']
    comment_like['api_standard_profile_request'] = comment_like['update_content']['person']['api_standard_profile_request']['url']
    comment_like.delete('update_content')
    comment_like['timestamp'] = Time.at(Integer( comment_like.delete('timestamp')) / 1000)
    if !comment_like['likes'].nil?
		
        result['likes'] = comment_like.delete('likes')
       
    end
    if !comment_like['update_comments'].nil?
        result['update_comments'] = comment_like.delete('update_comments')
    end
    return result
  end
  
  def initialize(hash)
	@hash = hash
    temp = process_hash(@hash)
    super(@hash)
    add_likes_from_comment_likes(temp['likes'])
	add_comments_from_comment_likes(temp['update_comments'])
  end

  def compare_hash(hash_from_database,hash_from_server)
    result = Hash.new
    hash_from_database.each { |key,value|
      if key.to_s != 'linkedin_user_id'.to_s && key.to_s != 'created_at'.to_s && key.to_s != 'updated_at'.to_s && value != hash_from_server[key]
        result[key] = hash_from_server[key]
      end
    }
    return result
  end


  def update_attributes(hash)
    hash = process_hash(hash)
    hash = compare_hash(self.attributes,hash)
    super(hash)
  end

end

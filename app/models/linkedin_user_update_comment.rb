class LinkedinUserUpdateComment < ActiveRecord::Base
  belongs_to :linkedin_user_comment_like,:foreign_key => "linkedin_user_comment_like_id"

  def self.process_hash(comment)
    if (comment.nil?)
      return nil
    end

    comment['linkedin_id'] = comment['person']['id']
    comment['first_name'] = comment['person']['first_name']
    comment['last_name'] = comment['person']['last_name']
    comment['headline'] = comment['person']['headline']
    comment['api_standard_profile_request'] = comment['person']['api_standard_profile_request']['url']
    comment['id'] = comment['person']['id']
    comment['site_standard_profile_request'] = comment['person']['site_standard_profile_request']['url']
    comment.delete('person')
    return comment
  end
  def self.from_comments(comment)
    if (comment.nil?)
      return nil
    end
    comment = self.process_hash(comment)
    li = self.new(comment)
    li
  end
  
  def self.update_comments(comment,linkedin_user_comment_like_id)
    if (comment.nil?)
      return nil
    end
    comment = self.process_hash(comment)
    li = self.find_all_by_linkdin_id_and_linkedin_user_comment_like_id(comment['linkedin_id'],linkedin_user_comment_like_id).first
    li.update_attributes(comment)
    li.save
  end


end

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
  def initialize(hash)
    hash = process_hash(hash)
    super(hash)

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

class LinkedinUserCurrentShare < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  def process_hash(current_share)
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

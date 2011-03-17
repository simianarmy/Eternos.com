class LinkedinUserConnection < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  def process_hash(connection)
    if (connection.nil?)
      return nil
    end
    connection.delete('headers')
    location = connection.delete('location')
    connection['location_code'] = location['country']['code']
    id = connection.delete('id')
    connection['linkedin_id'] = id
    connection['api_standard_profile_request']  = (connection.delete('api_standard_profile_request'))['url']
    connection['site_standard_profile_request'] = (connection.delete('site_standard_profile_request'))['url']

    return connection
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

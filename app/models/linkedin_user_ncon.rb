class LinkedinUserNcon < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
   def process_hash(ncon)
    if (ncon.nil?)
      return nil
    end
    ncon['linkedin_id'] = ncon['update-content']['person']['id']
    ncon['first_name']  = ncon['update-content']['person']['first_name']
    ncon['last_name']   = ncon['update-content']['person']['last_name']
    ncon['headline']    = ncon['update-content']['person']['headline']
    ncon['picture_url'] = ncon['update-content']['person']['picture_url']
    ncon['api_standard_profile_request'] = ncon['update-content']['person']['api_standard_profile_request']['url']
    ncon['site_standard_profile_request'] = ncon['update-content']['person']['site_standard_profile_request']['url']
    ncon.delete('update-content')
    return ncon
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

class LinkedinUserConnection < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
  def self.process_hash(connection)
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
  def self.from_connections(connection)
    if connection.nil?
      return nil
    end
   
    connection = self.process_hash(connection)
    li = self.new(connection)
    
    li
  end

  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end

end

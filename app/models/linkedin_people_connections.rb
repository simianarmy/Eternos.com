class LinkedinPeopleConnections < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_connections(connection)
  if connection.nil?
	return nil
  end	
    connection.delete('headers')
    location = connection.delete('location')
    connection['location_code'] = location['country']['code']
    id = connection.delete('id')
    connection['linkedin_id'] = id
    connection['api_standard_profile_request']  = (connection.delete('api_standard_profile_request'))['url']
    connection['site_standard_profile_request'] = (connection.delete('site_standard_profile_request'))['url']
    li = self.new(connection)
    
    li
  end
end

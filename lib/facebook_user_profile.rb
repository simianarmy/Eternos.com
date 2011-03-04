# $Id$

# Module contains helper methods that wrap Facebooker::User class methods
# for accessing Facebook Profile data

require 'facebooker'

module FacebookUserProfile
  # REST API fields
  Fields = Facebooker::User::FIELDS
  
  # OpenGraph fields.  Unfortunately not enumerated in Mogli
  OpenGraphFields = %w(id name first_name last_name gender locale link third_party_id timezone
    updated_time verified about bio birthday education email hometown interested_in location
    meeting_for political quotes relationship_status religion significant_other website work
  )
  OpenGraphAssociations = %w(activities interests music books movies television)
  
  # Wrapper for Facebooker's profile populate() method
  # Returns hash containing values for all user profile fields as defined in Fields array.
  
  def self.populate(facebook_user)
    returning Hash.new do |profile|
      begin
        facebook_user.populate(*Fields)
        Fields.each {|f| profile[f] = facebook_user.send(f)}
      rescue Exception => e
        Rails.logger.error "Facebooker error in populate: #{e.message}"
      end
      unless profile[:birthday_date].blank?
        profile[:birthday] = parse_model_date(profile[:birthday_date])
      end
    end
  end
  
  # Parses facebook models' date attribute strings into date objects
  def self.parse_model_date(dt)
    Date.parse(dt) rescue nil
  end
end
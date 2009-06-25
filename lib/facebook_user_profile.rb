# $Id$

# Module contains helper methods that wrap Facebooker::User class methods
# for accessing Facebook Profile data

require 'facebooker'

module FacebookUserProfile
  Fields = Facebooker::User::FIELDS
  
  # Wrapper for Facebooker's profile populate() method.
  # Returns hash containing values for all user profile fields as defined in Fields array.
  
  def self.populate(facebook_user)
    profile = {}
    facebook_user.populate(*Fields)
    Fields.each {|f| profile[f] = facebook_user.send(f)}
    profile
  end
end
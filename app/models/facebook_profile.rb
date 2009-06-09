class FacebookProfile < ActiveRecord::Base

  def self.convert_fb_profile_to_sync_with_local_setup(fb_hash)
    address_book = Hash.new
    profile = Hash.new
    address_book[:gender] = fb_hash[:sex]
    address_book[:birthdate] = fb_hash[:birthday]
    address_book[:first_name] = fb_hash[:first_name]
    address_book[:last_name] = fb_hash[:last_name]
    profile[:religion] = fb_hash[:religion]
    profile[:political_views] = fb_hash[:political]
    return address_book, profile
  end

end
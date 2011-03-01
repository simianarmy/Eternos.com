class LinkedinUserNcon < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"
   def self.process_hash(ncon)
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
  def self.from_ncons(ncon)
    
    ncon = self.process_hash(ncon)
    RAILS_DEFAULT_LOGGER.info "\n------NCON-----------------------#{ncon.inspect}-------------NCON--------------------------\n"
    li = self.new(ncon)
    li
  end
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end
end

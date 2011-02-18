class LinkedinPeopleNcons < ActiveRecord::Base
  belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_ncons(ncon)
    ncon['linkedin_id'] = ncon['update-content']['person']['id']
    ncon['first_name']  = ncon['update-content']['person']['first_name']
    ncon['last_name']   = ncon['update-content']['person']['last_name']
    ncon['headline']    = ncon['update-content']['person']['headline']
    ncon['picture_url'] = ncon['update-content']['person']['picture_url']
    ncon['api_standard_profile_request'] = ncon['update-content']['person']['api_standard_profile_request']['url']
    ncon['site_standard_profile_request'] = ncon['update-content']['person']['site_standard_profile_request']['url']
	ncon.delete('update-content')
    li = self.new(ncon)
    li
  end
end

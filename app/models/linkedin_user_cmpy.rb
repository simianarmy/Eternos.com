class LinkedinUserCmpy < ActiveRecord::Base
  belongs_to :linkedin_user, :foreign_key =>"linkedin_user_id"
  def self.process_hash(cmpy)
    if cmpy.nil?
      return nil
    end
    cmpy['timestamp'] = Time.at(Integer( cmpy.delete('timestamp')) / 1000)
    cmpy['company_name'] = cmpy['update_content']['company']['name']
    cmpy['company_id'] = cmpy['update_content']['company']['id']
    if !cmpy['update_content']['company_job_update'].nil?
      cmpy['job_update_action_code'] = cmpy['update_content']['company_job_update']['action']['code']
      cmpy['job_update_title'] = cmpy['update_content']['company_job_update']['job']['position']['title']
      cmpy['job_update_company_name'] = cmpy['update_content']['company_job_update']['job']['company']['name']
      cmpy['job_update_company_id'] = cmpy['update_content']['company_job_update']['job']['company']['id']
      cmpy['job_update_location_description'] = cmpy['update_content']['company_job_update']['job']['location_description']
      cmpy['job_request_url'] = cmpy['update_content']['company_job_update']['job']['site_job_request']['url']
      cmpy['job_update_id'] = cmpy['update_content']['company_job_update']['job']['id']
      cmpy['job_update_description'] = cmpy['update_content']['company_job_update']['job']['description']
    end
    if !cmpy['update_content']['company_update'].nil?
      cmpy['profile_update_id']  = cmpy['update_content']['company_update']['company_profile_update']['editor']['id']
      cmpy['profile_update_first_name'] = cmpy['update_content']['company_update']['company_profile_update']['editor']['first_name']
      cmpy['profile_update_last_name'] = cmpy['update_content']['company_update']['company_profile_update']['editor']['last_name']
      cmpy['profile_update_headline'] = cmpy['update_content']['company_update']['company_profile_update']['editor']['headline']
      cmpy['profile_update_action_code'] = cmpy['update_content']['company_update']['company_profile_update']['action']['code']
      cmpy['profile_update_field_code'] = cmpy['update_content']['company_update']['company_profile_update']['profile_field']['code']
      cmpy['profile_update_api_standard'] =  cmpy['update_content']['company_update']['company_profile_update']['api_standard_profile_request']['url']
      cmpy['profile_update_site_standard'] =  cmpy['update_content']['company_update']['company_profile_update']['site_standard_profile_request']['url']
    end
    if !cmpy['update_content']['company_person_update'].nil?
      cmpy['person_update_id'] = cmpy['update_content']['company_person_update']['person']['id']
      cmpy['person_update_first_name'] = cmpy['update_content']['company_person_update']['person']['first_name']
      cmpy['person_update_last_name'] = cmpy['update_content']['company_person_update']['person']['last_name']
      cmpy['person_update_headline'] = cmpy['update_content']['company_person_update']['person']['headline']
      cmpy['person_update_picture_url'] = cmpy['update_content']['company_person_update']['person']['picture_url']
      cmpy['person_update_api_standard'] = cmpy['update_content']['company_person_update']['person']['api_standard_profile_request']['url']
      cmpy['person_update_site_standard'] = cmpy['update_content']['company_person_update']['person']['site_standard_profile_request']['url']
      cmpy['person_update_action_code'] = cmpy['update_content']['company_person_update']['action']['code']
      cmpy['old_position_title'] = cmpy['update_content']['company_person_update']['old_position']['title']
      cmpy['old_position_company_name'] = cmpy['update_content']['company_person_update']['old_position']['company']['name']
      cmpy['new_position_title'] = cmpy['update_content']['company_person_update']['new_position']['title']
      cmpy['new_position_company_id'] = cmpy['update_content']['company_person_update']['new_position']['company']['id']
      cmpy['new_position_company_name'] = cmpy['update_content']['company_person_update']['new_position']['company']['name']

    end
    cmpy.delete('update_content')
    return cmpy
  end

  def self.from_cmpys(cmpy)
    cmpy = self.process_hash(cmpy)
    li = self.new(cmpy)
   
  end
  def self.update_cmpys(cmpy,user_id)
    cmpy = self.process_hash(cmpy)
    if cmpy.nil?
      return nil
    end
    cmpy = self.process_hash(cmpy)
    li = self.find_all_by_linkedin_user_id(user_id).first
    li.update_attributes(cmpy)
    li.save

  end

end

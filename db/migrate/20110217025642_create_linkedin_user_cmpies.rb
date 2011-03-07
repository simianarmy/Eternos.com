class CreateLinkedinUserCmpies < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_cmpies do |t|
      t.text      :job_request_url, :job_update_description, :person_update_headline, :person_update_picture_url
      t.integer   :company_id, :update_type, :job_update_id, :job_update_company_id, :new_position_company_id, :linkedin_user_id
      t.string    :company_name, :profile_update_id, :profile_update_first_name, :profile_update_last_name,
                  :profile_update_headline, :profile_update_api_standard, :profile_update_site_standard,
                  :profile_update_action_code, :profile_update_field_code, :job_update_title, :job_update_company_name,
                  :job_update_location_description, :job_update_action_code, :person_update_id, :person_update_first_name,
                  :person_update_last_name, :person_update_api_standard, :person_update_site_standard,
                  :person_update_action_code, :old_position_title, :old_position_company_name, :new_position_title, :new_position_company_name

      t.boolean   :is_commentable, :is_likable
	  t.timestamp :timestamp
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_cmpies
  end
end

class CreateLinkedinUserUpdateComments < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_update_comments do |t|
      t.string   :linkedin_id, :first_name, :last_name, :api_standard_profile_request, :site_standard_profile_request
      t.integer  :sequence_number, :linkedin_user_comment_like_id
      t.text     :comment, :headline
	  t.timestamp :timestamp
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_update_comments
  end
end

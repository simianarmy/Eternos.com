class CreateLinkedinUserConnections < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_connections do |t|
      t.string  :linkedin_id, :null => false
      t.string  :first_name,:last_name,:industry,:location_code
      t.integer :linkedin_user_id, :null => false
      t.text    :site_standard_profile_request,:headline,:api_standard_profile_request,:picture_url

      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_connections
  end
end

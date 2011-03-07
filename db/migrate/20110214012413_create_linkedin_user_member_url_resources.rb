class CreateLinkedinUserMemberUrlResources < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_member_url_resources do |t|
      t.string  :name
      t.text    :url
	  t.integer :linkedin_user_id, :null => false
      t.timestamps
	  
    end
  end

  def self.down
    drop_table :linkedin_user_member_url_resources
  end
end

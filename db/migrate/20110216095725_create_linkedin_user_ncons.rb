class CreateLinkedinUserNcons < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_ncons do |t|
      t.string  :linkedin_id
      t.string  :first_name
      t.string  :last_name
      t.text    :headline,:picture_url,:api_standard_profile_request,:site_standard_profile_request
      t.integer :is_commentable, :is_likable, :linkedin_user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_ncons
  end
end

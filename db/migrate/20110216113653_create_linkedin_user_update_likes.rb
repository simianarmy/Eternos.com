class CreateLinkedinUserUpdateLikes < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_update_likes do |t|
      t.string   :first_name, :last_name, :linkedin_id
      t.text  	 :headline, :picture_url
      t.integer  :linkedin_user_comment_like_id
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_update_likes
  end
end

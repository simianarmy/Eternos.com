class CreateLinkedinUserCommentLikes < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_comment_likes do |t|
      t.string   :update_key, :update_type, :linkedin_id, :first_name, :last_name,
        :api_standard_profile_request, :site_standard_profile_request
      t.integer  :num_likes, :linkedin_user_id
      t.boolean  :is_commentable, :is_likable, :is_liked
      t.text     :headline, :current_status, :picture_url
	t.timestamp :timestamp
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_comment_likes
  end
end

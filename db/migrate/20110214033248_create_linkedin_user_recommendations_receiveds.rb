class CreateLinkedinUserRecommendationsReceiveds < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_recommendations_receiveds do |t|
      t.string  :linkedin_id,:last_name,:first_name,:recommendation_type,:recommendation_id
	   t.integer   :linkedin_user_id, :null => false
      t.text    :recommendation_text
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_recommendations_receiveds
  end
end

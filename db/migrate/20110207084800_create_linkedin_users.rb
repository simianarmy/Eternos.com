class CreateLinkedinUsers < ActiveRecord::Migration

  def self.up
    create_table :linkedin_users do |t|
      t.string    :linkedin_id,:null => false
      t.string    :first_name,:null => false
      t.string    :last_name,:null => false
      t.integer   :backup_source_id,:null => false,:unsigned => true
      t.string    :location_code
      t.text      :headline,:industry,:current_status,:summary,:specialties,:proposal_comments,:associations,:honors,:interests,:main_address,:picture_url
      t.date      :date_of_birth
      t.boolean   :num_connections_capped
      t.integer   :distance,:num_connections,:num_recommenders
      t.timestamp :current_status_timestamp
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_users
  end
end

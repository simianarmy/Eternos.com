class CreateLinkedinUserCurrentShares < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_current_shares do |t|
      t.text      :comment
      t.timestamp :timestamp
      t.string    :linkedin_id,:first_name,:last_name,:source,:visibility,:current_share_id
	  t.integer :linkedin_user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_current_shares
  end
end

class CreateOnlineAccounts < ActiveRecord::Migration
  def self.up
    create_table :online_accounts do |t|
      t.integer :user_id
      t.enum :name, :limit => ["Twitter", "Flickr", "Facebook"], :default => "Twitter"
      t.string :username
      t.string :password
      t.boolean :disabled
      t.datetime :times_accessed
      t.datetime :last_accessed
      t.datetime :failed_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :online_accounts
  end
end

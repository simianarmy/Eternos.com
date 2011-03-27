class CreateLinkedinUserTwitterAccounts < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_twitter_accounts do |t|
      t.string  :provider_account_name,:provider_account_id
      t.integer :linkedin_user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_twitter_accounts
  end
end

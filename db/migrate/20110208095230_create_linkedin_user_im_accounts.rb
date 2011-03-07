class CreateLinkedinUserImAccounts < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_im_accounts do |t|
      t.string   :im_account_type,:im_account_name
      t.integer :linkedin_user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_im_accounts
  end
end

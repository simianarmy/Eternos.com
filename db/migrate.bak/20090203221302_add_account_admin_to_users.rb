class AddAccountAdminToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :account_admin, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :users, :account_admin
  end
end

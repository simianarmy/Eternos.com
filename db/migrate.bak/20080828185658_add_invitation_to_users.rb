# $Id$
class AddInvitationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invitation_id, :integer, :references => nil
    add_column :users, :invitation_limit, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :invitation_limit
    remove_column :users, :invitation_id
  end
end

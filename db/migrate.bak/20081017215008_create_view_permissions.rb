# $Id$
class CreateViewPermissions < ActiveRecord::Migration
  def self.up
    create_table :guest_permissions do |t|
      t.references :viewable, :polymorphic => true, :references => nil
      t.integer :user_id, :circle_id, :null => false
      t.integer :permissions, :unsigned => true, :default => 0
    end
  end

  def self.down
    drop_table :guest_permissions
  end
end

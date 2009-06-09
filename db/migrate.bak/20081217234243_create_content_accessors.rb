# $Id$
class CreateContentAccessors < ActiveRecord::Migration
  def self.up
    create_table :content_accessors do |t|
      t.integer :content_authorization_id
      t.integer :user_id, :references => nil
      t.integer :circle_id, :references => nil
      t.integer :permissions, :unsigned => true, :default => 0
      t.timestamps
    end
    
    change_table :content_authorizations do |t|
      t.remove :user_id, :circle_id, :permissions
      t.integer :privacy_level, :nil => false, :default => 0
    end
  end

  def self.down
    drop_table :content_accessors
    change_table :content_authorizations do |t|
      t.integer :user_id, :circle_id, :null => false, :references => nil
      t.integer :permissions, :unsigned => true, :default => 0
      t.remove :privacy_level
    end
  end
end

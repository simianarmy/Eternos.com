# $Id$
class RemoveFkFromContents < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.remove :user_id
      t.integer :user_id, :null => false, :default => 0, :references => nil
      t.remove :parent_id
      t.integer :parent_id, :references => nil
    end
  end

  def self.down
    change_table :contents do |t|
      t.remove :user_id
      t.integer :user_id, :null => false, :default => 0
      t.remove :parent_id
      t.integer :parent_id, :null => false, :default => 0
    end
  end
end

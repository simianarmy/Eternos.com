# $Id$
class AddForeignKeysToCircles < ActiveRecord::Migration
  def self.up
    change_table :circles do |t|
      t.integer :user_id, :null => false
    end
  end

  def self.down
    change_table :circles do |t|
      t.remove :user_id
    end
  end
end

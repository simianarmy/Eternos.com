# $Id$
class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.integer :user_id, :null => false, :default => 0, :references => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end

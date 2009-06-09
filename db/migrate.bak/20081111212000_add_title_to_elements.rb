# $Id$
class AddTitleToElements < ActiveRecord::Migration
  def self.up
    change_table :elements do |t|
      t.string :title
      t.remove :content_id
      t.datetime :start_at, :end_at
      t.integer :position
    end
  end

  def self.down
    change_table :elements do |t|
      t.remove :title, :start_at, :end_at, :position
      t.integer :content_id, :null => false, :default => 0
    end
  end
end

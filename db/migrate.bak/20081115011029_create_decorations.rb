# $Id$
class CreateDecorations < ActiveRecord::Migration
  def self.up
    create_table :decorations do |t|
      t.integer :element_id, :content_id, :null => false
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :decorations
  end
end

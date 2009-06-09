# $Id$
class CreateContent < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.integer :user_id, :size, :null => false, :default => 0
      t.string :type, :title, :filename, :null => false, :default => 'Document'
      t.string :thumbnail, :bitrate
      t.integer :parent_id, :width, :height
      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end

# $Id$
class CreateThumbnails < ActiveRecord::Migration
  def self.up
    create_table :photo_thumbnails do |t|
      t.integer :parent_id, :references => nil
      t.string :content_type
      t.string :filename
      t.string :thumbnail
      t.integer :size
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def self.down
    drop_table :photo_thumbnails
  end
end

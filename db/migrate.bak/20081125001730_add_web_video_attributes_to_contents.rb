# $Id$
class AddWebVideoAttributesToContents < ActiveRecord::Migration
  def self.up
    change_table :transcoded_videos do |t|
      t.remove :cdn_url
      t.string :fps
    end
    rename_table :transcoded_videos, :transcodings
    change_table :contents do |t|
      t.string :duration
    end
  end
  
  def self.down
    rename_table :transcodings, :transcoded_videos
    change_table :transcoded_videos do |t|
      t.string :cdn_url
      t.remove :fps
    end
    change_table :contents do |t|
      t.remove :duration
    end
  end
end

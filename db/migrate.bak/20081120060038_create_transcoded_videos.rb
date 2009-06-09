# $Id$
class CreateTranscodedVideos < ActiveRecord::Migration
  def self.up
    create_table :transcoded_videos do |t|
      t.integer :parent_id, :references => nil, :null => false
      t.integer :size
      t.string :filename, :width, :height, :duration, :video_codec, :audio_codec, :state, :processing_error_message, :cdn_url
      t.timestamps
    end
  end

  def self.down
    drop_table :transcoded_videos
  end
end

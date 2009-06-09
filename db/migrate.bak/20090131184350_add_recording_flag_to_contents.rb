class AddRecordingFlagToContents < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.boolean :recording, :null => false, :default => false
    end
  end

  def self.down
    change_table :contents do |t|
      t.remove :recording
    end
  end
end

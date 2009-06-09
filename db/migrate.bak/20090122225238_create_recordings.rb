class CreateRecordings < ActiveRecord::Migration
  def self.up
    create_table :recordings do |t|
      t.integer :user_id
      t.string :filename, :state, :null => false
      t.string :processing_error
      t.timestamps
    end
  end

  def self.down
    drop_table :recordings
  end
end

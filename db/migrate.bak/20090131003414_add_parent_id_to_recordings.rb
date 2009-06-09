class AddParentIdToRecordings < ActiveRecord::Migration
  def self.up
    change_table :recordings do |t|
      t.integer :parent_id, :references => nil
    end
  end

  def self.down
    change_table :recordings do |t|
      t.remove :parent_id
    end
  end
end

class AddFpsToContents < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.string :fps
    end
  end

  def self.down
    change_table :contents do |t|
      t.remove :fps
    end
  end
end

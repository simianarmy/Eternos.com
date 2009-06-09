class AddDescriptionToContents < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.text :description
    end
  end

  def self.down
    change_table :contents do |t|
      t.remove :description
    end
  end
end

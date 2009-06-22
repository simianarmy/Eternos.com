class AlterRelationshipsAddNameTypeNotes < ActiveRecord::Migration
  def self.up
    add_column :relationships, :name, :string
    add_column :relationships, :type, :string
    add_column :relationships, :notes, :text
    add_column :relationships, :start_at, :datetime
    add_column :relationships, :end_at, :datetime
  end

  def self.down
    remove_column :relationships, :name, :type, :notes, :start_at, :end_at 
  end
end

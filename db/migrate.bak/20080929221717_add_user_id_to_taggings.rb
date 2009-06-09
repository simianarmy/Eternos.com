# $Id$
class AddUserIdToTaggings < ActiveRecord::Migration
  def self.up
    add_column :taggings, :user_id, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :taggings, :user_id
  end
end

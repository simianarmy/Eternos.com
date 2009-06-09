# $Id$
class RemoveUserIdFromTaggings < ActiveRecord::Migration
  def self.up
    #remove_column :taggings, :user_id
  end

  def self.down
    add_column :taggings, :user_id, :integer, :null => false, :references => nil
  end
end

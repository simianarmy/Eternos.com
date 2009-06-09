# $Id$
class RemoveUserIdFromCategory < ActiveRecord::Migration
  def self.up
    change_table :categories do |t|
      t.remove :user_id
      t.boolean :global, :null => true, :default => false
    end
    Category.create :name => 'General', :global => true
  end

  def self.down
    Category.delete(:conditions => ['global = 1'])
    change_table :categories do |t|
      t.remove :global
      t.integer :user_id, :null => false
    end
  end
end

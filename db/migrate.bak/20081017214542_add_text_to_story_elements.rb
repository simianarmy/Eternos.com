# $Id$
class AddTextToStoryElements < ActiveRecord::Migration
  def self.up
    add_column :story_elements, :message, :text
  end

  def self.down
    remove_column :story_elements, :message
  end
end

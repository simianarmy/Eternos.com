# $Id$
class RenameStoryElementsToElements < ActiveRecord::Migration
  def self.up
    rename_table :story_elements, :elements
  end

  def self.down
    rename_table :elements, :story_elements
  end
end

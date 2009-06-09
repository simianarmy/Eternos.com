# $Id$
class CreateStoryElements < ActiveRecord::Migration
  def self.up
    create_table :story_elements do |t|
      t.integer :story_id
      t.integer :content_id
      t.timestamps
    end
  end

  def self.down
    drop_table :story_elements
  end
end

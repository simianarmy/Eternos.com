# $Id$
class CreateCategorizations < ActiveRecord::Migration
  def self.up
    create_table :categorizations do |t|
      t.integer :story_id, :category_id, :null => false
    end
  end

  def self.down
    drop_table :categorizations
  end
end

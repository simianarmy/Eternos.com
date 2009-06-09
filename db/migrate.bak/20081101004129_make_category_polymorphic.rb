# $Id$
class MakeCategoryPolymorphic < ActiveRecord::Migration
  def self.up
    drop_table :categorizations
    create_table :categorizations, :force => true do |t|
      t.integer :category_id, :null => false
      t.references :categorizable, :polymorphic => true, :references => nil
      t.timestamps
    end
  end
  
  def self.down
    #drop_table :categories_consumers
    drop_table :categorizations
    create_table :categorizations do |t|
      t.integer :story_id, :category_id, :null => false
    end
  end
end

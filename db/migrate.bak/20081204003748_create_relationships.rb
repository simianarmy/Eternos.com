# $Id$
class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :guest_id, :references => nil
      t.integer :circle_id, :references => nil
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :relationships
  end
end

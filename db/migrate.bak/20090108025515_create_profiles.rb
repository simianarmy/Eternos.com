# $Id$

class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id, :null => false
      t.string :height, :weight, :race, :gender, :religion, :political_views, :sexual_orientation,
      :nickname, :ethnicity, :children
      t.datetime :death_date
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end

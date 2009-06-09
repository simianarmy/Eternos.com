# $Id$

class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.integer :profile_id, :null => false
      t.integer :country_id, :null => false, :default => 0, :references => nil
      t.string :name, :degree, :fields
      t.date :start_at, :end_at
      t.string :activities_societies, :awards, :recognitions, :notes
    end
  end

  def self.down
    drop_table :schools
  end
end

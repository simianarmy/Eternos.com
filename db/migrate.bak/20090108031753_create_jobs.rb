# $Id$

class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :profile_id, :null => false
      t.string :company, :title, :description
      t.date :start_at, :end_at
    end
  end

  def self.down
    drop_table :jobs
  end
end

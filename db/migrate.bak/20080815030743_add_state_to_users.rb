# $Id$
class AddStateToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :state, :null => false, :default => 'passive'
      t.datetime :deleted_at
      end
  end

  def self.down
    change_table :users do |t|
      t.remove :state, :deleted_at
    end
  end
end

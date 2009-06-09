# $Id$

class UpdateAddresses < ActiveRecord::Migration
  def self.up
    change_table :addresses do |t|
      t.remove :street_1, :city, :postal_code
      t.string :street_1, :city, :postal_code
    end
  end

  def self.down
    change_table :addresses do |t|
      t.remove :street_1, :city, :postal_code
      t.string :street_1, :city, :postal_code, :null => false, :default => ''
    end
  end
end

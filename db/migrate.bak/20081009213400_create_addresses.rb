# $Id$
class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.references :addressable, :polymorphic => true, :references => nil
      t.string :location_type, :null => false
      t.string :street_1, :null => false
      t.string :street_2
      t.string :city, :null => false
      t.integer :region_id, :country_id, :references => nil
      t.string :custom_region
      t.string :postal_code, :null => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :addresses
  end
end

# $Id$
class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers do |t|
      t.references :phoneable, :polymorphic => true, :null => false, :references => nil
      t.string :phone_type, :null => false
      t.string :prefix
      t.string :area_code
      t.string :number
      t.string :extension
      t.timestamps
    end
  end

  def self.down
    drop_table :phone_numbers
  end
end

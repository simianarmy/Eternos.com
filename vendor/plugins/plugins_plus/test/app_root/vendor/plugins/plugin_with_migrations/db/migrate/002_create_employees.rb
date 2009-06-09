class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.references :company, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
    end
  end
  
  def self.down
    drop_table :employees
  end
end

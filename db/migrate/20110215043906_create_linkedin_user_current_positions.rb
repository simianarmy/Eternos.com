class CreateLinkedinUserCurrentPositions < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_current_positions do |t|
      t.integer :linkedin_user_id, :null => false
      t.text :title,:summary
      t.boolean :is_current
      t.date :start_date,:end_date
      t.string :company_name,:company_id,:company_industry
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_current_positions
  end
end

class CreateLinkedinUserPatentInventors < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_patent_inventors do |t|
      t.string  :linkedin_id,:first_name,:last_name
      t.integer :linkedin_user_patent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_patent_inventors
  end
end

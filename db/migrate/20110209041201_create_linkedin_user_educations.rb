class CreateLinkedinUserEducations < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_educations do |t|
    t.integer :linkedin_user_id, :null => false
    t.string  :school_name,:field_of_study,:education_id
    t.text    :degree,:activities,:notes
    t.integer :start_date,:end_date

    t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_educations
  end
end

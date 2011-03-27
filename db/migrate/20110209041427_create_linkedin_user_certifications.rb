class CreateLinkedinUserCertifications < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_certifications do |t|
      t.string  :name,:authority_name,:number,:certification_id
      t.date    :start_date,:end_date
      t.integer :linkedin_user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_certifications
  end
end

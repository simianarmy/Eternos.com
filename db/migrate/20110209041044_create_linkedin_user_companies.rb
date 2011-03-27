class CreateLinkedinUserCompanies < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_companies do |t|
      t.text      :name,:industry,:ticker
      t.integer   :size
      t.boolean   :type
      t.integer   :linkedin_user_id, :null => false
      t.integer   :linkedin_user_positions_linkedin_user_id,:null => false


      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_companies
  end
end

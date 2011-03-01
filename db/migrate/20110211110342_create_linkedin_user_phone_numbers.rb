class CreateLinkedinUserPhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :linkedin_user_phone_numbers do |t|
      t.string    :phone_type,:phone_number
	  t.integer   :linkedin_user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_user_phone_numbers
  end
end

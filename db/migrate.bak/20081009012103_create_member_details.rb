# $Id$
class CreateMemberDetails < ActiveRecord::Migration
  def self.up
    create_table :member_details do |t|
      t.integer :user_id, :null => false
      t.string :first_name, :last_name, :website, :icq, :skype, :msn, :aol
      t.binary :ssn_b
      t.date :birthdate
      t.string 
      t.timestamps
    end
  end

  def self.down
    drop_table :member_details
  end
end

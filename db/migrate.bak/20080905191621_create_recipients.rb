# $Id$
class CreateRecipients < ActiveRecord::Migration
  def self.up
    create_table :recipients do |t|
      t.integer :user_id, :null => false
      t.string :first_name, :last_name, :email, :alt_email
      t.timestamps
    end
  end

  def self.down
    drop_table :recipients
  end
end

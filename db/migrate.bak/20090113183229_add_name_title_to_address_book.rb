class AddNameTitleToAddressBook < ActiveRecord::Migration
  def self.up
    change_table :address_books do |t|
      t.string :name_title
    end
  end

  def self.down
    change_table :address_books do |t|
      t.remove :name_title
    end
  end
end

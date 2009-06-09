# $Id$
class AddToMemberDetails < ActiveRecord::Migration
  def self.up
    change_table :member_details do |t|
      t.string :middle_name, :name_suffix, :gender, :timezone
    end
  end

  def self.down
    change_table :member_details do |t|
      t.remove :middle_name, :name_suffix, :gender, :timezone
    end
  end
end

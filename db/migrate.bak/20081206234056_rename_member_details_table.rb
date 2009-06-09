# $Id$
class RenameMemberDetailsTable < ActiveRecord::Migration
  def self.up
    rename_table :member_details, :address_books
  end

  def self.down
    rename_table :address_books, :member_details
  end
end

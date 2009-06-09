# $Id$
class AddTakenAtToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :taken_at, :datetime
  end

  def self.down
    remove_column :contents, :taken_at
  end
end

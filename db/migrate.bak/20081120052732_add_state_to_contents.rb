# $Id$
class AddStateToContents < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.string :state, :processing_error_message, :cdn_url
      t.integer :version
    end
  end

  def self.down
    change_table :contents do |t|
      t.remove :state, :processing_error_message, :cdn_url, :version
    end
  end
end

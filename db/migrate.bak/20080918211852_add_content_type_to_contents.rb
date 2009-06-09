# $Id$
class AddContentTypeToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :content_type, :string
  end

  def self.down
    remove_column :contents, :content_type
  end
end

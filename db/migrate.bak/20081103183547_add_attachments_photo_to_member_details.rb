# $Id$
class AddAttachmentsPhotoToMemberDetails < ActiveRecord::Migration
  def self.up
    add_column :member_details, :photo_file_name, :string
    add_column :member_details, :photo_content_type, :string
    add_column :member_details, :photo_file_size, :integer
    add_column :member_details, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :member_details, :photo_file_name
    remove_column :member_details, :photo_content_type
    remove_column :member_details, :photo_file_size
    remove_column :member_details, :photo_updated_at
  end
end

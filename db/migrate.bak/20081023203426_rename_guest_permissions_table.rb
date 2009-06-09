# $Id$
class RenameGuestPermissionsTable < ActiveRecord::Migration
  def self.up
    rename_table :guest_permissions, :privacy_settings
    change_table :privacy_settings do |t|
      t.rename :viewable_id, :authorizable_id
      t.rename :viewable_type, :authorizable_type
    end
  end

  def self.down
    change_table :privacy_settings do |t|
      t.rename :authorizable_id, :viewable_id
      t.rename :authorizable_type,:viewable_type
    end
    rename_table :privacy_settings, :guest_permissions
  end
end

# $Id$
class RenamePrivacySettings < ActiveRecord::Migration
  def self.up
    drop_table :privacy_settings
    create_table :content_authorizations do |t|
      t.references :authorizable, :polymorphic => true, :references => nil
      t.integer :user_id, :circle_id, :null => false, :references => nil
      t.integer :permissions, :unsigned => true, :default => 0
    end
  end

  def self.down
    rename_table :content_authorizations, :privacy_settings
  end
end

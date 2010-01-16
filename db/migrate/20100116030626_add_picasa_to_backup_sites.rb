class AddPicasaToBackupSites < ActiveRecord::Migration
  def self.up
    BackupSite.create(:name => BackupSite::Picasa)
  end

  def self.down
    BackupSite.destroy(:name => BackupSite::Picasa)
  end
end

class AddLinkedinBackupsite < ActiveRecord::Migration
  def self.up
    BackupSite.create(:name => BackupSite::Linkedin)
  end

  def self.down
    BackupSite.destroy(:name => BackupSite::Linkedin)
  end
end

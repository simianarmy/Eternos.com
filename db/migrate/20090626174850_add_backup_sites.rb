class AddBackupSites < ActiveRecord::Migration
  def self.up
    BackupSite.create([
      {:name => 'facebook'}, {:name => 'twitter'}, {:name => 'gmail'}, {:name => 'flickr'}, {:name => 'blog'}
      ])
  end

  def self.down
    BackupSite.destroy_all
  end
end

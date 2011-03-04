# $Id$

module EternosBackup
  # DataSchedules
  #
  # Could be db-driven but for now contains static min. time intervals for each kind 
  # of backup data set
  module DataSchedules
    # Minimum backup intervals times for each data set
    MinDataBackupIntervals = {
      EternosBackup::SiteData::General                 => 24.hours, # default backup interval
      EternosBackup::SiteData::FacebookOtherWallPosts  => 24.hours,
      EternosBackup::SiteData::FacebookPhotoComments   => 24.hours
    }
    # Minium backup intervals times for failed backups for each data set 
    MinDataBackupRetryIntervals = {
      EternosBackup::SiteData::General                 => 4.hours, 
      EternosBackup::SiteData::FacebookOtherWallPosts  => 12.hours
    }
    
    class << self
      def min_backup_interval(ds)
        MinDataBackupIntervals.has_key?(ds) ? MinDataBackupIntervals[ds] : nil
      end
      
      def min_backup_retry_interval(ds)
        MinDataBackupRetryIntervals.has_key?(ds) ? MinDataBackupRetryIntervals[ds] : nil
      end
    end
  end
end
# $Id$

module EternosBackup
  # DataSchedules
  #
  # Could be db-driven but for now contains static min. time intervals for each kind 
  # of backup data set
  module DataSchedules
    # Minimum backup intervals times for each data set
    MinDataBackupIntervals = {
      EternosBackup::SiteData::General                 => 3.hours, # default backup interval
      EternosBackup::SiteData::FacebookOtherWallPosts  => 24.hours
    }

    class << self
      def min_backup_interval(ds)
        MinDataBackupIntervals.has_key?(ds) ? MinDataBackupIntervals[ds] : nil
      end
    end
  end
end
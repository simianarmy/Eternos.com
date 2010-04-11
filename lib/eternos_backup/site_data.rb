# $Id$
#
# Backup content module

module EternosBackup
  # SiteData
  #
  # Defines site & data-specific constants used by backup scheduler for specific
  # datatypes
  module SiteData
    General                 = 0 # Default - all data
    FacebookOtherWallPosts  = 1 # User's posts on friends' walls
    
    class << self
      def defaultDataSet
        General
      end
      
      # Takes BackupSite returns all possible backup data set codes for it
      def site_data_sets(site)
        if site.facebook?
          [defaultDataSet, FacebookOtherWallPosts]
        else
          [defaultDataSet]
        end
      end
    end
  end
end
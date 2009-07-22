# $Id$

# Downloads new backup photos from source and creates Photo object 
# for further processing (s3 upload, thumbnailing)
# Picks records randomly in so that sources don't block/rate-limit us by account

class BackupPhotoDownloader
  MaxDownloads = 100
  
  def self.run(max=MaxDownloads)
    BackupPhoto.needs_download.shuffle[0..max].each do |bp|
      RAILS_DEFAULT_LOGGER.debug "Downloading backup photo #{bp.id}..."
      sleep(1) # Don't flood source with download requests
      bp.starting_download!
      bp.download

      if bp.photo
        RAILS_DEFAULT_LOGGER.debug "Downloading complete"
        bp.download_complete!
      else
        RAILS_DEFAULT_LOGGER.error "Error downloading backup photo"
        bp.download_error!
      end
    end
  end
end
      
# $Id$

# Downloads new backup photos from source and creates Photo object 
# for further processing (s3 upload, thumbnailing)
# Picks records randomly in so that sources don't block/rate-limit us by account

class BackupPhotoDownloader
  MaxDownloads = 10000 # something large
  
  # Run by periodic rake task
  def self.run(max=MaxDownloads)
    # Run in em loop since rake tasks do not start amqp
    # TODO:
    # Perhaps if em started in thread with MessageQueue.start, 
    # jobs will be published immediately instead of all at once after 
    # block ends...
    MessageQueue.execute do
      # Why is shuffle causing undefined method `shuffle' for named_scope
      # but not from command line...obviously env paths..
      # using shuffle method code as work-around
      BackupPhoto.needs_download.sort_by {rand}[0..max.to_i].each do |bp|
        RAILS_DEFAULT_LOGGER.debug "Downloading backup photo #{bp.id}..."
        sleep(1) # Don't flood source with download requests
        bp.starting_download!
        
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
end
      

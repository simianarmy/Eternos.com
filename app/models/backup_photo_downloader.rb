# $Id$

# Downloads new backup photos from source and creates Photo object 
# for further processing (s3 upload, thumbnailing)
# Picks records randomly in so that sources don't block/rate-limit us by account

class BackupPhotoDownloader
  MaxDownloads = 10000 # something large
  
  # Run by periodic rake task
  def self.run(max=MaxDownloads)
    # Run in em loop since rake tasks do not start amqp
    # Run thread within EM loop, and sleep to pass control back 
    # to em to publish immediately
    MessageQueue.execute do
      RAILS_DEFAULT_LOGGER.info "Starting backup photo downloads"
      Thread.new do
        # Why is shuffle causing undefined method `shuffle' for named_scope
        # but not from command line...obviously env paths..
        # using shuffle method code as work-around
        BackupPhoto.needs_download.sort_by {rand}[0..max.to_i].each do |bp|
          RAILS_DEFAULT_LOGGER.debug "Downloading backup photo #{bp.id}..."
          download_photo bp
          sleep(0.3) # Don't flood source with download requests, and allow em to publish
        end
        RAILS_DEFAULT_LOGGER.info "Ending backup photo downloads"
      end
    end
  end
    
  # For development or in case we need to rebuild
  def self.rebuild_photos
    MessageQueue.start do
      Thread.new do
        # Get all backup photos with content objects (using batch find)
        BackupPhoto.state_equals('downloaded').find_each do |bp|
          # If photo downloaded but not uploaded to s3, start over
          if photo = bp.photo
            if photo.s3_key
              photo.rebuild_thumbnails unless photo.thumbnail && photo.thumbnail.s3_key
            else
              photo.destroy
              bp.download_error!
              download_photo bp
            end
          else # If no photo object, something went wrong
            bp.download_error!
            download_photo bp
          end
          sleep(0.3) # so em can publish upload job
        end
        MessageQueue.stop
      end
    end
  end
  
  # Tries to re-download prior failed photo downloads
  def self.fix_photos
    MessageQueue.execute do
      # Get all backup photos with content objects (using batch find)
      BackupPhoto.find_all_by_state([:downloaded, :failed_download]).each do |bp|
        unless bp.photo
          bp.download_error!
          download_photo bp
        end
      end
    end
  end
  
  # Tries to re-upload prior failed thumbnail downloads
  def self.fix_thumbnails
    MessageQueue.execute do
      PhotoThumbnail.state_does_not_equal('complete').find_each do |thumb|
        RAILS_DEFAULT_LOGGER.debug "Attempting to fix thumbnail #{thumb.id}"
        if thumb.staging?
          thumb.upload
        else
          thumb.stage!
        end
      end
    end
  end
  
  # Fix for facebook activity stream items with photo attachments not downloaded
  def self.download_photos_from_facebook_attachments 
    MessageQueue.execute do
      # (using batch find)
      FacebookActivityStreamItem.with_attachment.with_photo.find_each do |as|
        unless as.facebook_photo
          # if backup photo is there but some errors, destroy it
          if bp = as.backup_photo
            unless bp.backup_photo_album
              RAILS_DEFAULT_LOGGER.info "backup photo state: #{bp.state}"
              RAILS_DEFAULT_LOGGER.warn "destroying BackupPhoto for fb stream item #{as.id} because photo album not found"
              as.backup_photo.destroy
            end
          end
          RAILS_DEFAULT_LOGGER.info "creating BackupPhoto for fb stream item #{as.id}"
          as.send(:process_attachment)
        end
      end
    end
  end
  
  # starts the actual download job
  def self.download_photo(bp)
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
      

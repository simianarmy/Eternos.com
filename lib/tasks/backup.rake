# $Id$

# Backup-related rake tasks
# All require the Rails environment

namespace :backup do
  desc "Download new backup photos"
  task :download_photos => :environment do
    count = ENV['COUNT'] || 100
    BackupPhotoDownloader.run count.to_i
  end
  
  desc "Ensure backup photos properly saved" 
  task :fix_photos => :environment do
    BackupPhotoDownloader.fix_photos
  end
  
  desc "Ensure thumbnails properly created"
  task :fix_thumbnails => :environment do
    BackupPhotoDownloader.fix_thumbnails
  end
  
  desc "Ensure facebook photo activity stream attachments downloaded"
  task :download_fb_attachment_photos => :environment do
    BackupPhotoDownloader.download_photos_from_facebook_attachments
  end
  
  desc "Make sure all blog entries have screencaps"
  task :ensure_feed_screencaps => :environment do
    FeedEntry.all.each do |fe|
      (fe.feed_content || fe.create_feed_content).save_screencap unless fe.screencap_url
    end
  end
  
  desc "Generate backup jobs"
  task :run_scheduled => :environment do
    cutoff = ENV['FORCE'] ? Time.now : nil
    BackupScheduler.run :cutoff => cutoff
  end
  
  desc "Run backup on a single source by id" 
  task :run_source => :environment do
    unless id = ENV['SOURCE']
      puts "pass backup source id in SOURCE parameter" 
      exit
    end
    if bs = BackupSource.find(id)
      BackupJobPublisher.add_source(bs)
      puts "backup source #{id} added to backup job queue"
    else
      puts "Could not find backup source with id #{id}"
    end
  end
  
  desc "Run backup for a source type"
  task :run_site => :environment do
    unless site = ENV['SITE']
      puts "pass site name in SITE parameter"
      puts "options: #{BackupSite.names.join('|')}"
      exit
    end
    if site = BackupSite.find_by_name(site)
      BackupJobPublisher.add_by_site(site)
    else
      puts "Could not find backup site (options: #{BackupSite.names.join('|')})"
    end
  end

  desc "Assign backup photo albums to backup photo -> photo objects"
  task :migrate_backup_photo_albums => :environment do
    BackupPhoto.with_photo.reject{|bp| !bp.photo}.each do |bp|
      bp.photo.update_attribute(:collection, bp.backup_photo_album) unless bp.photo.collection
    end
  end 
  
  desc "Disables backup sources with too many backup errors"
  task :disable_failed_backup_sources => :environment do
    BackupSource.find_each do |bs|
      bs.backup_error_max_reached! if bs.backup_broken?
    end
  end
end

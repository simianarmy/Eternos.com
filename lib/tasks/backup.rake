# $Id$

# Backup-related rake tasks
# All require the Rails environment

namespace :backup do
  def remove_file(f)
    if File.exists? f
      puts "Removing #{f}"
      FileUtils.rm f
    end
  end
  
  desc "Download new backup photos"
  task :download_photos => :environment do
    count = ENV['COUNT'] || 100
    BackupPhotoDownloader.run count.to_i
  end
  
  desc "Ensure backup photos properly saved" 
  task :fix_photos => :environment do
    BackupPhotoDownloader.fix_photos
  end
  
  task :cleanup_local_assets => :environment do
    Content.s3_key_not_nil.find_each do |c|
      remove_file(c.full_filename)
    end
    PhotoThumbnail.s3_key_not_nil.find_each do |thumb|
      remove_file(thumb.full_filename)
    end
  end
  
  desc "Ensure thumbnails properly created"
  task :fix_thumbnails => :environment do
    BackupPhotoDownloader.fix_thumbnails
  end
  
  desc "Ensure facebook photo activity stream attachments downloaded"
  task :download_fb_attachment_photos => :environment do
    BackupPhotoDownloader.download_photos_from_facebook_attachments
  end
  
  desc "Ensure downloaded photos have been saved to cloud"
  task :ensure_content_saved_to_cloud => :environment do
    require 'content_uploader'
    ContentUploader.upload_all
  end
  
  desc "Make sure all blog entries have screencaps"
  task :ensure_feed_screencaps => :environment do
    FeedEntry.find_each do |fe|
      (fe.feed_content || fe.create_feed_content).save_screencap unless fe.screencap_url
    end
  end
  
  desc "Make sure all email files are uploaded"
  task :upload_email_files => :environment do
    require 'email_uploader'
    EmailUploader.upload_all
  end
  
  desc "Generate backup jobs"
  task :run_scheduled => :environment do
    cutoff = ENV['FORCE'] ? Time.now.utc : nil
    EternosBackup::BackupScheduler.run :cutoff => cutoff
  end
  
  desc "Run backup on a single source by id" 
  task :run_source => :environment do
    unless id = ENV['SOURCE']
      puts "pass backup source id in SOURCE parameter" 
      exit
    end
    opts = {}
    if ENV['DATASET']
      opts[:dataType] = ENV['DATASET'].to_i
    end
    if bs = BackupSource.find(id)
      EternosBackup::BackupJobPublisher.add_source([bs], opts)
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
      EternosBackup::BackupJobPublisher.add_by_site(site)
    else
      puts "Could not find backup site (options: #{BackupSite.names.join('|')})"
    end
  end
  
  desc "Run long facebook backups"
  task :run_long_facebook => :environment do
    EternosBackup::BackupJobPublisher.add_by_site(BackupSite.find_by_name(BackupSite::Facebook), 
      :dataType => EternosBackup::SiteData::FacebookOtherWallPosts)
  end
  
  desc "Run backup for recently failed backups caused by db connection errors"
  task :rebackup_failed_from_db_max_error => :environment do
    sources = BackupSourceJob.created_at_gt(24.hours.ago).error_messages_like('could not obtain a database connection').map(&:backup_source).uniq.compact

    puts "rebackup for sources #{sources.map(&:id).join(',')}"
    EternosBackup::BackupJobPublisher.add_source(sources, {})
   end
 
  desc "Assign backup photo albums to backup photo -> photo objects"
  task :migrate_backup_photo_albums => :environment do
    BackupPhoto.with_photo.reject{|bp| !bp.photo}.each do |bp|
      bp.photo.update_attribute(:collection, bp.backup_photo_album) unless bp.photo.collection
    end
  end 
  
  # This should be run about 1/week or as needed.
  desc "Disables backup sources with too many backup errors"
  task :disable_failed_backup_sources => :environment do
    BackupSource.active.find_each do |bs|
      bs.backup_error_max_reached! if bs.backup_broken?
    end
  end

  desc "Count backup sources with too many backup errors"
  task :count_failed_backup_sources => :environment do
    count = 0
    BackupSource.active.find_each do |bs|
      count += 1 if bs.backup_broken?
    end
    puts "#{count} failed backup sources"
  end
end

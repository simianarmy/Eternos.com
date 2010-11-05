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
  
  def get_backup_opts
    returning({}) do |opts|
      opts[:cutoff] = ENV['FORCE'] ? Time.now.utc : nil
      if ENV['DATASET']
        opts[:dataType] = ENV['DATASET'].to_i
      end
      if ENV['MAX']
        opts[:max_jobs] = ENV['MAX'].to_i
      end
    end
  end
  
  desc "Download new backup photos"
  task :download_photos => :environment do
    if count = ENV['COUNT']
      BackupPhotoDownloader.run count.to_i
    else
      BackupPhotoDownloader.run
    end
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
    MessageQueue.start do
      Thread.abort_on_exception = true
      t1 = Thread.new do
        Lockfile('ensure_feed_screencaps', :retries => 0) do
          if ENV['FEED_ENTRY_ID']
            if fe = FeedEntry.find(ENV['FEED_ENTRY_ID'])
              fe.ensure_screencap
            else
              puts "No FeedEntry found."
            end
          else
            FeedEntry.find_each do |fe|
              fe.ensure_screencap
            end
          end
        end
      end # Thread.new
      t1.join
      puts "Done"
      MessageQueue.stop
    end
  end
  
  desc "Make sure all email files are uploaded"
  task :upload_email_files => :environment do
    require 'email_uploader'
    EmailUploader.upload_all
  end
  
  desc "Generate backup jobs"
  task :run_scheduled => :environment do
    opts = get_backup_opts
    EternosBackup::BackupScheduler.run opts
  end
  
  desc "Run backup on a single source by id" 
  task :run_source => :environment do
    unless id = ENV['SOURCE']
      puts "pass backup source id in SOURCE parameter" 
      exit
    end
    opts = get_backup_opts
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
  
  desc "Run backups for recent joins"
  task :run_recent_accounts => :environment do
    unless days_old = ENV['CREATED_DAYS_AGO']
      puts "Specify how far back to get members with CREATED_DAYS_AGO parameter"
      exit
    end
    cutoff = days_old.to_i.days.ago
    opts = get_backup_opts.merge({:cutoff => cutoff,
      :member_created_after => cutoff})
    EternosBackup::BackupScheduler.run opts
  end
  
  desc "Run backup for recently failed backups caused by db connection errors"
  task :rebackup_failed_from_db_max_error => :environment do
    sources = BackupSourceJob.created_at_gt(24.hours.ago).error_messages_like('could not obtain a database connection').map(&:backup_source).uniq.compact

    puts "rebackup for sources #{sources.map(&:id).join(',')}"
    EternosBackup::BackupJobPublisher.add_source(sources, {})
  end
 
  desc "Prints all pending backup jobs"
  opts = get_backup_opts
  task :print_pending_jobs => :environment do
    File.open(File.join(Rails.root, "tmp", "backup_jobs_scheduled.txt"), 'w+') do |log|
      EternosBackup::BackupScheduler.get_pending_backups(opts).each do |member, jobs|
        jobs.each do |job|
          log.puts EternosBackup::BackupReporter.job_to_s(job)
        end
      end
    end
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
  
  desc "Shows backup status for a single user"
  task :user_status => :environment do
    unless login = ENV['LOGIN']
      puts "Usage: rake backup:user_status LOGIN=email@address"
      exit
    end
    unless m = User.email_eq(login).first
      puts "Could not find a user with login: #{login}"
      exit
    end
    puts "Backup State: "
    puts m.backup_state.inspect
    puts 
    puts "Recent jobs: "
    m.backup_sources.each do |bs|
      puts "SOURCE ID = #{bs.id}"
      puts bs.description
      if job = bs.latest_backup
        puts job.inspect
      else
        puts "None"
      end
    end
  end
    
end

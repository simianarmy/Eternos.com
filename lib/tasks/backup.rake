# $Id$

# Backup-related rake tasks
# All require the Rails environment

namespace :backup do
  desc "Download new backup photos"
  task :download_photos => :environment do
    BackupPhotoDownloader.run
  end
  
  desc "Generate backup jobs"
  task :publish_jobs => :environment do
    BackupJobPublisher.run
  end
  
  desc "Generate backup job reports"
  task :generate_report => :environment do
    BackupReporter.run
  end
end
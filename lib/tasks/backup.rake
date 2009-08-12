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
  
  desc "Generate backup jobs"
  task :publish_jobs => :environment do
    BackupJobPublisher.run
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
  
  desc "Generate backup job reports"
  task :generate_report => :environment do
    BackupReporter.run
  end
end

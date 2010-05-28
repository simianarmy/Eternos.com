# $Id$

namespace :reports do
  namespace :backup do
    desc "Generate backup storage use report"
    task :storage => :environment do
      EternosBackup::BackupReporter.storage_usage
    end

    desc "Generate daily backup jobs report"
    task :jobs => :environment do
      EternosBackup::BackupReporter.backup_jobs
    end

    desc "Display all pending backup jobs"
    task :print_pending => :environment do
      EternosBackup::BackupScheduler.run :report => true
    end
    
    desc "Generate all backup-related reports"
    task :all => [:storage, :jobs]
  end
end
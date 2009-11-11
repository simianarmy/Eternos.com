# $Id$

namespace :reports do
  namespace :backup do
    desc "Generate backup storage use report"
    task :storage => :environment do
      BackupReporter.storage_usage
    end

    desc "Generate daily backup jobs report"
    task :jobs => :environment do
      BackupReporter.backup_jobs
    end

    desc "Generate all backup-related reports"
    task :all => [:storage, :jobs]
  end
end
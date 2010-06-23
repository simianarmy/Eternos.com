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
    task :pending_jobs => :environment do
      EternosBackup::BackupScheduler.get_pending_backups.each do |member, sources|
        sources.each do |s|
          puts "#{member.id} => " + [s[0].id, s[0].description, s[1][:dataType], s[0].member.backup_state.try(:last_successful_backup_at)].join(':')
        end
      end
    end
    
    desc "Generate all backup-related reports"
    task :all => [:storage, :jobs]
  end
  
  def show_member_activity(m)
    if m.backup_sources.any?
      puts "#{m.email} #{m.id}"
      m.backup_sources.each do |bs|
        puts "#{bs.id} => #{bs.description}"
        puts "Confirmed? #{bs.auth_confirmed?}"
      end
      puts "Backup items?: #{m.backup_state.try(:items_saved)}"
    end
  end
  
  desc "Displays stats on recent accounts"
  task :recent_members => :environment do
    Member.created_at_gt(2.days.ago).each do |m|
      if ENV['SHOW_WITHOUT_DATA']
        show_member_activity(m) unless m.backup_state.try(:items_saved)
      else
       show_member_activity(m) 
      end 
    end
  end
end
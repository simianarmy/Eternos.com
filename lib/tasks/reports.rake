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
    
    desc "Generate all backup-related reports"
    task :all => [:storage, :jobs]
    
    desc "Count recent successful backups by type"
    task :count_recent_backups_by_type => :environment do
      unless site = ENV['SITE']
        puts "pass site name in SITE parameter"
        puts "options: #{BackupSite.names.join('|')}"
        exit
      end
      total_jobs = 0
      failed_jobs = 0
      good_jobs = 0
      errors_by_kind = Hash.new(0)
      processed_sources = {}
      BackupSourceJob.finished_at_gt(1.day.ago).backup_source_backup_site_name_eq(site).each do |bsj|
        total_jobs += 1
        if bsj.successful?
          good_jobs += 1
        else
          failed_jobs += 1
          errors_by_kind[bsj.error_messages.first] += 1
        end
        processed_sources[bsj.backup_source_id] = 1
      end
      puts <<STATS
  Total: #{total_jobs}
  Failed: #{failed_jobs}
  Success: #{good_jobs}
  Unique Sources: #{processed_sources.size}
  Unique Errors: #{errors_by_kind.size}
STATS

    end
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
  
  desc "Displays member s3 storage use" 
  task :member_s3_size => :environment do
    u = Member.find(ENV['ID'])
    puts "Member #{u.name} S3 storage use: " << u.s3_storage_used
  end 
end

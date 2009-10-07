# $Id$

class BackupScheduler
  @@run_interval = 4.hours
  cattr_accessor :run_interval
  cattr_writer :cutoff
  cattr_reader :cutoff_time
  
  class << self  
    def run(options={})
      @@cutoff = options[:cutoff] || cutoff_time
      
      # Get members that qualify for backup
      MessageQueue.execute do
        Member.needs_backup(@@cutoff).each do |member|
          # Get all backup sources that should be backed up
          sources = member.backup_sources.active.select {|bs| source_scheduled_for_backup?(bs)}
          # Send sources to job publisher
          BackupJobPublisher.run(member, sources) if sources.any?
        end
      end
    end

    # Determines if a backup source can be scheduled for backup
    def source_scheduled_for_backup?(bs)
      return true unless latest_job = BackupSourceJob.backup_source_id_eq(bs.id).newest
      return false unless latest_job.finished? 
      RAILS_DEFAULT_LOGGER.debug "latest backup job: #{latest_job.inspect}"
      
      latest_job.successful? ? (latest_job.finished_at < cutoff_time) : true
    end
    
    def cutoff_time
      @@cutoff ||= (Time.now - run_interval)
    end
    
    def next_source_backup_at(bs)
      if bs.active?
        scheduled = if bs.last_backup_at
          bs.last_backup_at + run_interval
        elsif source_scheduled_for_backup?(bs)
          next_run_time
        end
        # Don't schedule for sometime in the past
        (scheduled <= Time.now) ? next_run_time : scheduled
      end
    end
    
    # next top of the hour
    def next_run_time
      Time.now.utc + (60 - Time.now.strftime("%M").to_i).minutes
    end
  end
end
      
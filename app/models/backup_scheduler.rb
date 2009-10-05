# $Id$

class BackupScheduler
  @@run_interval = 4.hours
  cattr_reader :run_interval
  
  class << self  
    def run(options={})
      @cutoff = options[:cutoff] || (Time.now - self.run_interval)    
      # Get members that qualify for backup
      MessageQueue.execute do
        Member.needs_backup(@cutoff).each do |member|
          # Get all backup sources that should be backed up
          sources = member.backup_sources.active.select {|bs| source_scheduled_for_backup?(bs, :cutoff => @cutoff)}
          # Send sources to job publisher
          BackupJobPublisher.run(member, sources) if sources.any?
        end
      end
    end

    # Determines if a backup source can be scheduled for backup
    def source_scheduled_for_backup?(bs, options={})
      return true unless latest_job = BackupSourceJob.backup_source_id_eq(bs.id).newest
      return false unless latest_job.finished? 

      cutoff = options[:cutoff] || (Time.now - self.run_interval)    
      
      latest_job.successful? ? (latest_job.finished_at < cutoff) : true
    end
    
    def next_source_backup_at(bs)
      'sometime'
    end
  end
end
      
# $Id$

# Class to handle finding pending backup job users & sending their info to 
# a message queue.


class BackupJobPublisher
  # Adds member backup job requests to backup queue for all eligible members
  # Should be called periodically from some cron-like utility
  def self.run(cutoff_time = 1.day.ago)
    MessageQueue.execute do
      q = MessageQueue.pending_backup_jobs_queue
    
      Member.needs_backup(cutoff_time).with_backup_targets.each do |member|
        member.backup_in_progress! 
        q.publish BackupJobMessage.new.member_payload(member)
        RAILS_DEFAULT_LOGGER.info "Sent backup job to queue for member #{member.name} (#{member.id})"
      end
      RAILS_DEFAULT_LOGGER.info "Backup jobs published.  Stopping amqp loop"
    end
  end

  
  # Adds backup job request to backup queue for a single backup source
  def self.add_source(backup_source)
    MessageQueue.execute do
      backup_queue.publish BackupJobMessage.new.source_payload(backup_source)
    end
    RAILS_DEFAULT_LOGGER.info "Sent backup job to queue for backup source (#{backup_source.id})"
  end
  
end
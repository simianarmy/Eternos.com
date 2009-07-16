# $Id$

# Class to handle finding pending backup job users & sending their info to 
# a message queue.


class BackupJobPublisher
  # Adds member backup job requests to backup queue for all eligible members
  # Should be called periodically from some cron-like utility
  def self.run
    connect_to_backup_queue do |q|
      Member.needs_backup(2.days.ago).with_backup_targets.each do |member|
        RAILS_DEFAULT_LOGGER.info "Sending backup job to queue for member #{member.name} (#{member.id})"
        member.backup_in_progress! 
        q.publish(BackupJobMessage.new.member_payload(member))
      end
      RAILS_DEFAULT_LOGGER.info "BackupJobPublisher::run: finished."
    end
  end
  
  # Adds backup job request to backup queue for a single backup source
  def self.add_source(backup_source)
    connect_to_backup_queue do |q|
      RAILS_DEFAULT_LOGGER.info "Sending backup job to queue for backup source (#{backup_source.id})"
      q.publish BackupJobMessage.new.source_payload(backup_source)
    end
  end
  
  private
  
  # Initiates eventmachine reactor pattern for a message queue connection
  # Yields backup jobs queue
  # Expects: block
  def self.connect_to_backup_queue
    RAILS_DEFAULT_LOGGER.info "BackupJobPublisher: connecting to message queue server..."
    MessageQueue.start do
      yield MessageQueue.pending_backup_jobs_queue
      MessageQueue.stop_loop 
    end
  end
end
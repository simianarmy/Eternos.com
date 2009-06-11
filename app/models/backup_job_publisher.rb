# $Id$

# Class to handle finding pending backup job users & sending their info to 
# a message queue.
# Should be called periodically from some cron-like utility

class BackupJobPublisher
  def self.run
    RAILS_DEFAULT_LOGGER.info "BackupJobPublisher::run: connecting to message queue server..."
    MessageQueue.start do
      backup_q = MessageQueue.pending_backup_jobs_queue
    
      Member.needs_backup(1.week.ago).with_backup_targets.each do |member|
        RAILS_DEFAULT_LOGGER.info "Sending backup job to queue for member #{member.name} (#{member.id})"
        member.backup_in_progress!
        backup_q.publish(BackupJobMessage.new.payload(member))
      end
      AMQP.stop { EM.stop_event_loop }
      RAILS_DEFAULT_LOGGER.info "BackupJobPublisher::run: finished."
    end
  end
end
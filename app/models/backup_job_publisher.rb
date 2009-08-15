# $Id$

# Class to handle finding pending backup job users & sending their info to 
# a message queue.


class BackupJobPublisher
  class << self
    # Adds member backup job requests to backup queue for all eligible members
    # Should be called periodically from some cron-like utility
    def run(cutoff_time = 1.day.ago)
      MessageQueue.execute do
        q = MessageQueue.pending_backup_jobs_queue
        
        Member.needs_backup(cutoff_time).with_backup_targets.uniq.each do |member|
          member.backup_in_progress! 
          q.publish BackupJobMessage.new.member_payload(member)
          RAILS_DEFAULT_LOGGER.info "Sent backup job to queue for member #{member.name} (#{member.id})"
        end
      end
    end


    # Adds backup job request to backup queue for a single backup source
    def add_source(backup_source)
      MessageQueue.execute do
        publish_source MessageQueue.pending_backup_jobs_queue, backup_source
      end
    end

    # Adds backup job requests to backup queue for a backup site type
    def add_by_site(site)
      MessageQueue.execute do
        q = MessageQueue.pending_backup_jobs_queue
        
        Member.with_backup_targets.uniq.each do |u|
          u.backup_sources.by_site(site.name).each do |source|
            publish_source q, source
          end
        end
      end
    end
    
    def publish_source(q, source)
      q.publish BackupJobMessage.new.source_payload(source)
      RAILS_DEFAULT_LOGGER.info "Sent backup job to queue for backup source (#{source.id})"
    end
  end
end
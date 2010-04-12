# $Id$

# Class to handle finding pending backup job users & sending their info to 
# a message queue.

module EternosBackup
  class BackupJobPublisher
    class BackupJobMessage
      # Returns payload object for a member and multiple backup sources
      def member_payload(member, *sources)
        payload(member.id, *sources)
      end

      private

      # source format: [BackupSource, dataTypeName]
      def source_to_h(source)
        {:id => source[0].id, :source => source[0].backup_site.type_name, :options => source[1]}
      end

      def payload(id, *sources)
        {:user_id => id, :target_sites => sources.compact.map {|s| source_to_h(s)}}.to_yaml
      end
    end

    class << self
      # Adds member backup jobs to backup queue
      # sources format: array of [[BackupSource object, options Hash], ...]
      def run(member, sources)
        MessageQueue.execute do
          q = MessageQueue.pending_backup_jobs_queue
          member.backup_in_progress! 
          publish_sources q, member, *sources
        end
      end

      # Adds backup job request to backup queue for a single backup source
      def add_source(backup_source, options={})
        options.reverse_merge! :dataType => EternosBackup::SiteData.defaultDataSet
        
        MessageQueue.execute do
          publish_sources(MessageQueue.pending_backup_jobs_queue, backup_source.member, 
            [backup_source, options])
        end
      end

      # Adds backup job requests to backup queue for a backup site type
      def add_by_site(site, options={})
        options.reverse_merge! :dataType => EternosBackup::SiteData.defaultDataSet
  
        MessageQueue.execute do
          q = MessageQueue.pending_backup_jobs_queue

          Member.active.each do |m|
            sources = m.backup_sources.active.by_site(site.name).map {|s| [s, options]}
            publish_sources(q, m, *sources) if sources.any?
          end
        end
      end

      private

      def publish_sources(q, member, *sources)
        q.publish payload = BackupJobMessage.new.member_payload(member, *sources)
        RAILS_DEFAULT_LOGGER.info "Sent backup payload to queue: #{payload.inspect}"
      end
    end
  end
end
# $Id$

# Class to handle finding pending backup job users & sending their info to 
# a message queue.

module EternosBackup
  class BackupJobPublisher
    # BackupJobMessage
    #
    # Class for creating single backup job message to send to backup job work queues
    # Returns encoded representation of job data
    
    class BackupJobMessage
      attr_reader :site_name, :data_type
      
      # Takes user object and source data array [source, options]
      # Any additional options will be encoded in the options attribute 
      def initialize(member, source, options={})
        @job_id   = UUIDTools::UUID.random_create.to_s # Create unique uuid string
        @member   = member
        @source   = source
        @options  = options
        @site_name = source.backup_site.type_name
        @data_type = options[:dataType]
      end
      
      
      # Specifies message's json structure.  Caller uses to_json
      def as_json(options={})
        payload(@member.id, @source, @options)
      end
      
      private

      # source format: [BackupSource, dataTypeName]
      def source_to_h(source, options)
        {:id => source.id, :source => @site_name, :options => options}
      end

      def payload(id, source, options)
        {:job_id => @job_id, :user_id => id, :target => source_to_h(source, options)}
      end
    end

    class << self
      include EternosBackup::QueueRunner
      
      # Adds member backup jobs to backup queue
      # sources format: array of [[BackupSource object, options Hash], ...]
      def run(member, sources)
        run_backup_job do
          member.backup_in_progress! 
          publish_sources member, *sources
        end
      end

      # run without mq wrapper
      def run_inside_mq(member, sources)
        member.backup_in_progress! 
        publish_sources member, *sources
      end
      
      # Adds backup job request to backup queue for one or more backup sources
      def add_source(*backup_sources)
        options = backup_sources.extract_options!
        options[:dataType] ||= EternosBackup::SiteData.defaultDataSet
        
        run_backup_job do
          backup_sources.flatten.reject{|bs| bs.member.nil?}.each do |backup_source|
            publish_sources(backup_source.member, [backup_source, options])
          end
        end
      end

      # Adds backup job requests to backup queue for a backup site type
      def add_by_site(site, options={})
        options.reverse_merge! :dataType => EternosBackup::SiteData.defaultDataSet
  
        run_backup_job do
          BackupSource.active.by_site(site.name).find_each do |bs|
            sources = [bs, options]
            if m = bs.member 
              publish_sources(m, sources)
            end
          end
        end
      end

      private

      # Publish a message to worker queue for each source
      def publish_sources(member, *sources)
        sources.each do |src|
          # Encode payload to json & send to rabbitmq topic exchange using source+data type as key
          job = BackupJobMessage.new(member, src[0], src[1])
          payload = job.to_json
          Rails.logger.debug "Sending backup job: #{payload.to_json}"
          
          # 'Normal' datasets = short jobs
          if job.data_type.nil? || (job.data_type == EternosBackup::SiteData.defaultDataSet)
            # Send to topic exchange
            MessageQueue.backup_worker_topic.publish(payload, 
              :key => MessageQueue.backup_worker_topic_route(job.site_name))
            Rails.logger.info "Sent backup payload to topic exchange for #{job.site_name}"
          else # others = long jobs
            # Send to long job queue
            MessageQueue.long_backup_worker_queue.publish(payload)
            Rails.logger.info "Sent backup payload to long worker queue"
          end
        end
      end
    end
  end
end
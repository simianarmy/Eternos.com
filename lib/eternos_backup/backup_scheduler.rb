# $Id$

module EternosBackup
  
  class BackupScheduler
    cattr_writer :cutoff
    cattr_reader :cutoff_time

    class << self
      include EternosBackup::QueueRunner
      
      # Using central DataSchedules module for default min. backup run interval timers
      def default_run_interval  
        EternosBackup::DataSchedules.min_backup_interval(EternosBackup::SiteData.defaultDataSet)
      end

      # Run in EM reactor to publish pending backup jobs to MQ
      def run(options={})
        @@cutoff = options[:cutoff] || cutoff_time

        run_backup_job do
          # Get members that qualify for backup
          member_sources = get_pending_backups(@@cutoff, options)
          count = 0
          
          # Using member.backup_state.last_successful_backup_at as sort key
          member_sources.keys.sort { |a, b|
            atime = a.backup_state ? a.backup_state.last_successful_backup_at.to_i : 0
            btime = b.backup_state ? b.backup_state.last_successful_backup_at.to_i : 0
            atime <=> btime
          }.each do |member|
            sources = member_sources[member]
            # Send sources to job publisher
            EternosBackup::BackupJobPublisher.run(member, sources) 
            count += 1
            break if options[:max_jobs] && (count >= options[:max_jobs])
          end
        end
      end
      
      # Meat of the backup scheduler.  Process each member with at least 1 backup source.
      # Returns hash containing:
      # Member => [[backup_source1, :dataType => datattype], [backupsource1, :dataType => datatype2], ...]
      #   
      def get_pending_backups(cutoff=nil, options={})
        returning({}) do |member_sources|
          # Do all members needing a backup
          members = if options[:member_created_after] 
            Member.created_at_gt(options[:member_created_after]).with_sources
          else
            Member.needs_backup(cutoff)
          end
          members.each do |member|
            # Get all backup sources,datatypes that should be backed up          
            member.backup_sources.active.each do |bs|
              bs.backup_data_sets.each do |ds|
                next if options[:dataType] && (ds != options[:dataType])
                
                # Get latest backup job record for this backup source & data set
                latest_job = BackupSourceJob.backup_source_id_eq(bs.id).backup_data_set_id_eq(ds).newest
            
                if source_scheduled_for_backup?(latest_job, bs, ds) 
                  # Save member-latest job pair for sorting later
                  # Save member-sources pair for lookup by member id later
                  (member_sources[member] ||= []) << [bs, {:dataType => ds}]
                end
              end
            end
          end
        end
      end
      
      # Calculates estimated next backup run time for some backup source (and optional data set)
      # TODO: update for dataset support
      def next_source_backup_at(bs, ds=EternosBackup::SiteData.defaultDataSet)
        if bs.active?
          scheduled = if bs.last_backup_at
            bs.last_backup_at + default_run_interval
          elsif source_scheduled_for_backup?(bs, ds)
            next_run_time
          end
          # Don't schedule for sometime in the past
          (scheduled.nil? || (scheduled <= Time.now.utc)) ? next_run_time : scheduled
        end
      end
      
      protected
      
      # Determines if a backup source can be scheduled for backup
      def source_scheduled_for_backup?(latest_job, bs, data_set)
        # Definitely needs backup if no backup jobs have been created for it
        return true if latest_job.nil?
        
        #puts "latest backup job for #{bs.description} (ds: #{data_set}) finished at #{latest_job.finished_at}"

        if latest_job.finished?
          # If last job finished successfully, compare finish time to cutoff
          if latest_job.successful? 
            latest_job.finished_at < cutoff_time(data_set)
          else
            # otherwise, schedule it if error did not occur too recently
            time_since_failed = (Time.now.utc - latest_job.finished_at)
            retry_interval = EternosBackup::DataSchedules.min_backup_retry_interval(data_set)
            #puts "Last job failed #{time_since_failed} ago"
            #puts "ds retry interval = #{retry_interval}"
            #puts "scheduling? #{time_since_failed > retry_interval}"
            time_since_failed > retry_interval
          end
        else
          # handle case where job crashes without saving error or finish time
          latest_job.expired?(data_set)
        end      
      end

      # Returns the cutoff time = the latest time a backup job can have completed before we can 
      # schedule the next backup
      def cutoff_time(ds=EternosBackup::SiteData.defaultDataSet)
        min_interval = EternosBackup::DataSchedules.min_backup_interval(ds) || default_run_interval
        Time.now.utc - min_interval
      end

      # next top of the hour
      def next_run_time
        Time.now.utc + (60 - Time.now.strftime("%M").to_i).minutes
      end
    end
  end
end

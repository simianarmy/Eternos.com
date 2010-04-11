# $Id$

module EternosBackup
  class BackupScheduler
    cattr_writer :cutoff
    cattr_reader :cutoff_time

    class << self
      # Using central DataSchedules module for default min. backup run interval timers
      def default_run_interval  
        EternosBackup::DataSchedules.min_backup_interval(EternosBackup::SiteData.defaultDataSet)
      end
      
      def run(options={})
        @@cutoff = options[:cutoff] || cutoff_time

        # Get members that qualify for backup
        MessageQueue.start do
          # Make sure to send backup jobs in random order every time to prevent early 
          # members from getting preference
          Member.needs_backup(@@cutoff).sort_by { rand }.each do |member|
            # Get all backup sources,datatypes that should be backed up
            # Result should be array with format: 
            # [[backup_source1, :dataType => datattype], [backupsource1, :dataType => datatype2], ...]
            sources = []
            member.backup_sources.active.each do |bs|
              bs.backup_data_sets.each do |ds|
                if source_scheduled_for_backup?(bs, ds)
                  sources << [bs, {:dataType => ds}]
                end
              end
            end
            Rails.logger.debug "sources scheduled for backup: #{sources.inspect}"
            sources.compact! # Remove nils
            # Send sources to job publisher
            EternosBackup::BackupJobPublisher.run(member, sources) if sources.any?
          end
          MessageQueue.stop
        end
      end

      # Determines if a backup source can be scheduled for backup
      def source_scheduled_for_backup?(bs, data_set)
        return true unless latest_job = BackupSourceJob.backup_source_id_eq(bs.id).backup_data_set_id_eq(data_set).newest
        Rails.logger.debug "latest backup job for #{bs.description} (ds: #{data_set}): #{latest_job.inspect}"

        if latest_job.finished?
          latest_job.successful? ? (latest_job.finished_at < cutoff_time(data_set)) : true
        else
          # handle case where job crashes without saving error or finish time
          latest_job.expired?
        end      
      end

      # Returns the cutoff time = the latest time a backup job can have completed before we can 
      # schedule the next backup
      def cutoff_time(ds=EternosBackup::SiteData.defaultDataSet)
        min_interval = EternosBackup::DataSchedules.min_backup_interval(ds) || default_run_interval
        Time.now - min_interval
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
          (scheduled.nil? || (scheduled <= Time.now)) ? next_run_time : scheduled
        end
      end

      # next top of the hour
      def next_run_time
        Time.now.utc + (60 - Time.now.strftime("%M").to_i).minutes
      end
    end
  end
end

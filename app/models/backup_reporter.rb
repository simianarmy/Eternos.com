# $Id$

# detailed statistics on storage (along with costs for S3 storage) for our current user base, 
# including average size of data stores.

module S3PriceCalculator
  class << self
    def calculate_monthly_storage_cost(bytes)
      per_gig = bytes.to_f / 1.gigabyte.to_f
      if bytes < 50.terabytes
        per_gig * 0.15
      elsif bytes < 100.terabytes
        per_gig * 0.14
      elsif bytes < 500.terabytes
        per_gig * 0.13
      else
        per_gig * 0.12
      end
    end
  end
end

class BackupReporter
  # Collect metrics on members' space usage and send out in mail
  class << self 
    def run
      #storage_usage
      backup_jobs
    end

    private

    def storage_usage
      # Collect each member's total backup db records, number of each backup item, 
      # total emails size, & estimated photos disk space usage.
      # Totals and past day's stats
      total       = {}
      total_avg   = {}
      latest      = {}
      latest_avg  = {}

      stats = [:backup_items, :backup_size, :backup_s3_size].each do |s|
        total[s] = total_avg[s] = latest[s] = latest_avg[s] = 0
      end

      backup_items = %w( ActivityStreamItem BackupPhotoAlbum BackupPhoto BackupEmail Feed FeedEntry )
      backup_items.each do |bi|
        key = bi.tableize.to_sym
        klass = bi.constantize

        total[key.to_s + '_size']   ||= 0
        latest[key.to_s + '_size']  ||= 0

        size = klass.first.respond_to?(:bytes) ? klass.all.collect(&:bytes).compact.sum : 0
        total[key]   = klass.count
        total[key.to_s + '_size'] += size
        total[:backup_items] += total[key]
        total[:backup_size] += size

        last_day = klass.created_at_greater_than_or_equal_to(1.day.ago)
        size = last_day.first.respond_to?(:bytes) ? last_day.collect(&:bytes).compact.sum : 0
        latest[key]  = last_day.count
        latest[key.to_s + '_size'] += size
        latest[:backup_items] += latest[key]
        latest[:backup_size] += size
      end

      # Calculate s3 costs
      total[:backup_s3_size] = BackupPhoto.all.collect(&:bytes).compact.sum + BackupEmail.sum(:size)
      total[:s3_cost] = S3PriceCalculator.calculate_monthly_storage_cost(total[:backup_s3_size])

      latest[:backup_s3_size] = BackupPhoto.created_at_greater_than_or_equal_to(1.day.ago).collect(&:bytes).compact.sum +
      BackupEmail.created_at_greater_than_or_equal_to(1.day.ago).sum(:size)
      latest[:s3_cost] = S3PriceCalculator.calculate_monthly_storage_cost(total[:s3_cost])

      nusers = Member.active.count
      total.each_key do |k| 
        total_avg[k] = total[k] / nusers
        latest_avg[k] = latest[k] / nusers
      end

      BackupReportMailer.deliver_daily_storage_report(:total => total, :latest => latest, 
      :total_avg => total_avg, :latest_avg => latest_avg, :num_users => nusers)
    end


    # Generate previous days's backup jobs report for performance analysis & 
    # error detection in beta software
    def backup_jobs
      data = []
      jobs = BackupJob.all#BackupJob.by_date Date.yesterday
      jobs.each do |job|
        data << {:job => job, :source_jobs => job.backup_source_jobs, :state => job.member.backup_state}
      end
      BackupReportMailer.deliver_daily_jobs_report(data)
    end
  end
end


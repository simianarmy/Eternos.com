# $Id$

# detailed statistics on storage (along with costs for S3 storage) for our current user base, 
# including average size of data stores.

module EternosBackup
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

          # Use batch iterator to prevent massive memory consumption
          size = klass.first.respond_to?(:bytes) ? sum_with_method(klass, :bytes) : 0

          total[key]   = klass.count
          total[key.to_s + '_size'] += size
          total[:backup_items] += total[key]
          total[:backup_size] += size

          # Use batch iterator to prevent massive memory consumption
          last_day = klass.created_at_greater_than_or_equal_to(1.day.ago)
          size = last_day.first.respond_to?(:bytes) ? sum_with_method(last_day, :bytes) : 0

          latest[key]  = last_day.count
          latest[key.to_s + '_size'] += size
          latest[:backup_items] += latest[key]
          latest[:backup_size] += size
        end

        # Calculate s3 costs

        # Use batch iterator to prevent massive memory consumption
        size = sum_with_method(BackupPhoto, :bytes)
        total[:backup_s3_size] = size + BackupEmail.sum(:size)
        total[:s3_cost] = S3PriceCalculator.calculate_monthly_storage_cost(total[:backup_s3_size])

        latest[:backup_s3_size] = BackupPhoto.created_at_greater_than_or_equal_to(1.day.ago).collect(&:bytes).compact.sum +
        BackupEmail.created_at_greater_than_or_equal_to(1.day.ago).sum(:size)
        latest[:s3_cost] = S3PriceCalculator.calculate_monthly_storage_cost(total[:s3_cost])

        user_count = Member.active.size
        user_with_data_count = Member.active.with_data.size

        total.each_key do |k| 
          total_avg[k] = total[k] / user_count
          latest_avg[k] = latest[k] / user_count
        end

        ActionMailer::Base.delivery_method = :sendmail
        BackupReportMailer.deliver_daily_storage_report(:total => total, :latest => latest, 
        :total_avg => total_avg, :latest_avg => latest_avg, :num_users => user_count,
        :num_users_with_data => user_with_data_count)
      end


      # Generate previous days's backup jobs report for performance analysis & 
      # error detection in beta software
      def backup_jobs
        data = {}
        jobs = BackupJob.by_date Date.yesterday
        # Group by member
        jobs.reject{|j| j.member.nil?}.each do |job|
          (data[job.member] ||= []) << {:job => job, :source_jobs => job.backup_source_jobs}
        end
        ActionMailer::Base.delivery_method = :sendmail
        BackupReportMailer.deliver_daily_jobs_report(data)
      end

      protected

      # With find_in_batches 
      def sum_with_method(klass, method)
        sum = 0
        klass.find_in_batches do |ks|
          ks.each {|k| sum += k.send(method) rescue 0}
        end
        sum
      end
    end
  end
end
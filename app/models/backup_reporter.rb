# $Id$

# detailed statistics on storage (along with costs for S3 storage) for our current user base, 
# including average size of data stores.
 
class BackupReporter
  # Collect metrics on members' space usage and send out in mail
  def self.run
    # Collect each member's total backup db records, number of each backup item, 
    # total emails size, & estimated photos disk space usage.
    total       = {}
    total_avg   = {}
    latest      = {}
    latest_avg  = {}
    
    stats = [:backup_items,
      :backup_db_size,
      :backup_s3_size].each do |s|
        total[s] = total_avg[s] = latest[s] = latest_avg[s] = 0
    end
    
    backup_items = %w( ActivityStreamItem BackupPhotoAlbum BackupPhoto BackupEmail Feed FeedEntry )
    backup_items.each do |bi|
      key = bi.tableize.to_sym
      klass = bi.constantize
      
      total[key.to_s + '_size']   ||= 0
      latest[key.to_s + '_size']  ||= 0
      
      size = klass.first.respond_to?(:bytes) ? klass.all.map(&:bytes).sum : 0
      total[key]   = klass.count
      total[key.to_s + '_size'] += size
      total[:backup_items] += total[key]
      total[:backup_db_size] += size
      
      last_day = klass.created_at_greater_than_or_equal_to(1.day.ago)
      size = last_day.first.respond_to?(:bytes) ? last_day.map(&:bytes).sum : 0
      latest[key]  = last_day.count
      latest[key.to_s + '_size'] += size
      latest[:backup_items] += latest[key]
      latest[:backup_db_size] += size
    end
    users = Member.active.count
    total.each_key do |k| 
      total_avg[k] = total[k] / users
      latest_avg[k] = latest[k] / users
    end
    puts "Totals"
    puts total.inspect
    puts "Latest"
    puts latest.inspect
    puts "Averages per #{users} users"
    puts total_avg.inspect
    puts latest_avg.inspect
  end
end
    
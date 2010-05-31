# $Id$
#
# Admin munin controller

class Admin::MuninController < ApplicationController
  @@API_KEY = 'FL1mFl4mAlamB' # Password to match requests against
  @@MuninSampleInterval = 5.minutes
  
  before_filter :check_api_key
  
  # Returns general user sessions & member counts
  def users
    user_count = Member.active.size
    user_with_data_count = Member.active.with_data.size
    active_sessions = Member.last_request_at_gt(24.hours.ago).size
    closed = Member.closed.size
    
    response =<<RESP
sessions = #{active_sessions}
total = #{user_count}
active = #{user_with_data_count}
closed = #{closed}
RESP
    render :inline => response, :status => :ok
  end
  
  # Returns live backup job stats assuming munin sample rate of 1 / 5 minutes
  def running_backup_jobs
    backups_running = {}
    backups_finished = {}
    backups = {}
    BackupSite.names.each { |site| backups[site] = backups_running[site] = backups_finished[site] = 0 }
    
    BackupSourceJob.created_at_gt(Time.now.utc - @@MuninSampleInterval).each do |job|
      site = job.backup_source.backup_site.name rescue 'Unknown'
      backups[site] += 1
      if job.finished? 
        backups_finished[site] += 1
      else
        backups_running[site] += 1
      end
    end
    response = ""
    backups.each do |site, count|
      response += "#{site} = #{count}\n"
    end
    
    render :inline => response, :status => :ok
  end
  
  def backup_job_avg_run_times
    backup_counts = Hash.new(0)
    backup_times = Hash.new(0)
    site_names = {}
    
    # Cache backup site id => names for later
    BackupSite.find_each do |bs| 
      site_names[bs.id] = bs.name
      site = bs.name
      backup_times[site] = backup_counts[site] = 0
    end
    
    BackupSourceJob.created_at_gt(24.hours.ago).find(:all, :include => :backup_source, :conditions => ['finished_at > 0']) do |job|
      if site_id = job.backup_source.try(:backup_site_id)
        site = site_names[site_id]
        backup_counts[site] += 1
        backup_times[site] += (job.finished_at - job.created_at)
      end
    end
    response = ""
    backup_times.each do |site, count|
      avg_time = backup_counts[site] > 0 ? (backup_times[site] / backup_counts[site]) : 0
      response += "#{site} = #{avg_time.to_i}\n"
    end
    
    render :inline => response, :status => :ok
  end
  
  # Backup errors in last 24 hours
  def backup_job_errors
    errs = BackupSourceJob.created_at_gt(24.hours.ago).count(:conditions => ['finished_at > 0 AND error_messages != ?', ''])
    response = errs
    
    render :inline => response, :status => :ok
  end
  
  def facebook_session_errors
    errs = BackupSourceJob.created_at_gt(24.hours.ago).error_messages_like('Facebook: Session key invalid').size
    response = errs
    
    render :inline => response, :status => :ok
  end
  
  # Returns backup data storage sizes & counts
  def backup_items
    facebook_records = FacebookActivityStreamItem.count
    twitter_records = TwitterActivityStreamItem.count
    facebook_photos = BackupPhoto.count(:include => {:backup_photo_album => {:backup_source => :backup_site}}, 
      :conditions => ['backup_sites.name = ?', BackupSite::Facebook])
    picasa_photos =   BackupPhoto.count(:include => {:backup_photo_album => {:backup_source => :backup_site}}, 
        :conditions => ['backup_sites.name = ?', BackupSite::Picasa])
    rss_entries = FeedEntry.count
    rss_feeds = Feed.count
    emails = BackupEmail.count
    
    response =<<RESP
facebook = #{facebook_records}
twitter = #{twitter_records}
facebook_photos = #{facebook_photos}
picasa_photos = #{picasa_photos}
rss_items = #{rss_entries}
rss_feeds = #{rss_feeds}
emails = #{emails}
RESP

    render :inline => response, :status => :ok
  end
  
  def backup_sites
    facebook = BackupSource.facebook.count
    twitter = BackupSource.twitter.count
    rss = BackupSource.blog.count
    gmail = BackupSource.gmail.count
    picasa = BackupSource.picasa.count
    
    response =<<RESP
facebook = #{facebook}
twitter = #{twitter}
rss = #{rss}
gmail = #{gmail}
picasa = #{picasa}
RESP
  
    render :inline => response, :status => :ok
  end
   
  protected
  
  def check_api_key
    render :nothing => true, :status => 401 unless params[:api] == @@API_KEY
  end
end

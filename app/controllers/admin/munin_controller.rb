# $Id$
#
# Admin munin controller

class Admin::MuninController < ApplicationController
  @@API_KEY = 'FL1mFl4mAlamB' # Password to match requests against
  @@MuninSampleInterval = 5.minutes
  
  before_filter :check_api_key
  before_filter :load_backup_sites, :only => [:running_backup_jobs, :backup_job_avg_run_times]
  
  # Returns general user sessions & member counts
  def users
    user_count = Member.active.size
    user_with_data_count = Member.active.with_data.count
    user_with_source_count = Member.active.with_sources.all.uniq.size
    active_sessions = Member.last_request_at_gt(24.hours.ago).size
    closed = Member.closed.size
    
    response =<<RESP
sessions = #{active_sessions}
total = #{user_count}
setup = #{user_with_source_count}
active = #{user_with_data_count}
closed = #{closed}
RESP
    render :inline => response, :status => :ok
  end
  
  # Returns live backup job stats assuming munin sample rate of 1 / 5 minutes
  def running_backup_jobs
    backups_running = {}
    long_backups_running = Hash.new(0)
    backups = {}
    @backup_sites.values.each { |site| backups[site] = backups_running[site] = 0 }
    
    BackupSourceJob.created_at_gt(1.day.ago).finished_at_eq(nil).each do |job|
      site = job.backup_source.backup_site.name rescue 'Unknown'
      backups[site] += 1      
      if job.backup_data_set_id == EternosBackup::SiteData.defaultDataSet
        backups_running[site] += 1
      else
        long_backups_running[site] += 1
      end
    end
    response = ""
    backups.each do |site, count|
      response += "#{site} = #{count}\n"
    end
    long_backups_running.each do |site, count|
      response += "#{site}_long = #{count}\n"
    end
    
    render :inline => response, :status => :ok
  end
  
  def backup_job_avg_run_times
    backup_counts = Hash.new(0)
    backup_times = Hash.new(0)
    site_names = {}
    
    @backup_sites.values.each do |site| 
      backup_times[site] = backup_counts[site] = 0
    end
    
    BackupSourceJob.finished_at_gt(munin_start_time).find(:all, :include => :backup_source).each do |job|
      if site_id = job.backup_source.try(:backup_site_id)
        site = @backup_sites[site_id]
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
  
  def backup_jobs_success
    jobs = {:success => 0, :failed => 0, :expired => 0, :unknown => 0}
    BackupSourceJob.finished_at_gt(munin_start_time).each do |job|
      if job.successful?
        jobs[:success] += 1
      elsif job.has_errors?
        jobs[:failed] += 1
      elsif job.expired?
        jobs[:expired] += 1
      else
        jobs[:unknown] += 1
      end
    end
    response = ""
    jobs.each do |k,v|
      response += "#{k} = #{v.to_i}\n"
    end
    
    render :inline => response, :status => :ok
  end
        
  # Backup errors in last 24 hours
  def backup_job_errors
    errs = Hash.new(0)
    errs[:none] = 0
    BackupSourceJob.finished_at_gt(munin_start_time).find(:all, :conditions => ['error_messages != ?', '']).each do |job|
      errs[job.error_messages.to_s] += 1
    end
    response = ""
    errs.each do |k,v|
      response += "#{k} = #{v.to_i}\n"
    end
    
    render :inline => response, :status => :ok
  end
  
  def facebook_session_errors
    errs = BackupSourceJob.finished_at_gt(munin_start_time).error_messages_like('Facebook: Session key invalid').size
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
    facebook_active = BackupSource.facebook.active.count
    twitter = BackupSource.twitter.count
    twitter_active = BackupSource.twitter.active.count
    rss = BackupSource.blog.count
    rss_active = BackupSource.blog.active.count
    gmail = BackupSource.gmail.count
    gmail_active = BackupSource.gmail.active.count
    picasa = BackupSource.picasa.count
    picasa_active = BackupSource.picasa.active.count
    
    response =<<RESP
facebook = #{facebook}
twitter = #{twitter}
rss = #{rss}
gmail = #{gmail}
picasa = #{picasa}
facebook_active = #{facebook_active}
twitter_active = #{twitter_active}
rss_active = #{rss_active}
gmail_active = #{gmail_active}
picasa_active = #{picasa_active}
RESP
  
    render :inline => response, :status => :ok
  end
   
  protected
  
  def check_api_key
    render :nothing => true, :status => 401 unless params[:api] == @@API_KEY
  end
  
  def load_backup_sites
    # Cache backup site id => names for later
    @backup_sites = {}
    BackupSite.all.each {|bs| @backup_sites[bs.id] = bs.name }
  end
  
  def munin_start_time
    Time.now.utc - @@MuninSampleInterval
  end
end

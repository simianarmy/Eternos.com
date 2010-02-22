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

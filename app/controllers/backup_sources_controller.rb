# $Id$

require 'twitter'

class BackupSourcesController < ApplicationController
  before_filter :login_required
  require_role "Member"

  def index
    @need_setup = current_user.need_backup_setup?
    respond_to do |format|
      format.js { 
        render :json => {:need_setup => @need_setup}
      }
    end
  end
    
  def add_twitter
    begin
      backup_site = BackupSite.find_by_name(BackupSite::Twitter)
      base = Twitter::Base.new(Twitter::HTTPAuth.new(params[:backup_source][:auth_login], params[:backup_source][:auth_password]))
      
      if base.verify_credentials            
        backup_source = current_user.backup_sources.by_site(BackupSite::Twitter).find_by_auth_login(params[:backup_source][:auth_login])
        if backup_source.nil?
          backup_source = current_user.backup_sources.new(params[:backup_source].merge({:backup_site_id => backup_site.id}))
          if backup_source.save
            backup_source.confirmed!
            current_user.completed_setup_step(2)
            @activated = true
            flash[:notice] = "Activated!"
          end 
        else
          flash[:notice] = "Twitter account is already activated"
        end
      else
        flash[:error] = "Twitter account is not valid"
      end
      
      find_twitter_account
    rescue
       flash[:error] = "Twitter account is not valid"
    end
    
    respond_to do |format|
      format.js
    end
  end

  def remove_twitter_account
    begin
      remove_account(BackupSite::Twitter, params[:id])
    rescue
      flash[:error] = "Could not find twitter account to remove"
    end
    find_twitter_account
    find_twitter_confirmed
    
    respond_to do |format|
      format.js
    end
  end
  
  def add_feed_url
    begin
      @feed_url = FeedUrl.new(:user_id => current_user.id, 
        :rss_url => params[:feed_url][:rss_url], 
        :backup_site_id => BackupSite.find_by_name(BackupSite::Blog).id)
      if @feed_url.save
        @feed_url.confirmed!
        current_user.completed_setup_step(2)
        
        # Get paginated list of feeds, ordered by most recent
        @feed_urls = current_user.backup_sources.by_site(BackupSite::Blog).paginate(
        :page => params[:page], :per_page => 10, :order => 'created_at DESC')
      else
        flash[:error] = @feed_url.errors.full_messages
      end
    rescue
      flash[:error] = "Unexpected error adding this feed!"
    end
    
    respond_to do |format|
      format.js
    end
  end 
  
  def remove_url
    begin
      remove_account(BackupSite::Blog, params[:id])
    rescue
      flash[:error] = "Could not find rss account to remove"
    end
    @feed_urls = current_user.backup_sources.by_site(BackupSite::Blog).paginate :page => params[:page], :per_page => 10
    find_rss_confirmed
    
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def find_twitter_account
    @twitter_accounts = current_user.backup_sources.by_site(BackupSite::Twitter).paginate :page => params[:page], :per_page => 10
  end
  
  def find_twitter_confirmed
    @twitter_account   = current_user.backup_sources.by_site(BackupSite::Twitter).first
    @twitter_confirmed = @twitter_account && @twitter_account.confirmed?
  end
  
  def find_rss_confirmed
    @rss_url = current_user.backup_sources.by_site(BackupSite::Blog).first
    @rss_confirmed = @rss_url && @rss_url.confirmed?
  end
  
  def remove_account(type, id)
    current_user.backup_sources.by_site(type).find(id).destroy
  end
end
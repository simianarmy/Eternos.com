# $Id$

require 'twitter'

class BackupSourcesController < ApplicationController
  before_filter :login_required
  require_role "Member"

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
           
            @rjs_message = "activated"
          end 
        else
          @rjs_message = "Twitter account is already activated"
        end
      else
        @rjs_message = "Twitter account is not valid"
      end
      
      find_twitter_account
      respond_to do |format|
        format.js
      end
    rescue
       render_message("Twitter account is not valid")
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
  
  # TODO: Needs exception handling
  def add_feed_url
    if @feed_url = FeedUrl.create(:user_id => current_user.id, 
        :rss_url => params[:feed_url][:rss_url], 
        :backup_site_id => BackupSite.find_by_name(BackupSite::Blog).id)
      @feed_url.confirmed!
      
      # Get paginated list of feeds, ordered by most recent
      @feed_urls = current_user.backup_sources.by_site(BackupSite::Blog).paginate(
        :page => params[:page], :per_page => 10, :order => 'created_at DESC')
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

  def render_message(message)
    @rjs_message =  message
    respond_to do |format|
      format.js{
        render :update do |page|
           page.replace_html "rjs-message", :partial => "shared/rjs_message", :layout => false
           page.visual_effect :highlight, 'rjs-message'
           page.delay(4) do
              page[:flashmessage].remove                            
           end
        end
      }
    end
  end
  
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
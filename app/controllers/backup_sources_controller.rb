# $Id$

require 'twitter'

class BackupSourcesController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  def create
    begin
      if params[:site_name]
        backup_site = BackupSite.find_by_name(params[:site_name])
        base = Twitter::Base.new(Twitter::HTTPAuth.new(params[:backup_source][:auth_login], params[:backup_source][:auth_password]))
        if base.verify_credentials            
          backup_source = current_user.backup_sources.by_site(BackupSite::Twitter).find_by_auth_login(params[:backup_source][:auth_login])
          if backup_source.nil?
            backup_source = current_user.backup_sources.new(params[:backup_source].merge({:backup_site_id => backup_site.id}))
            if backup_source.save
              backup_source.confirmed!
              #backup_source.backup  Initiate backup!
              message = "activated"
            end 
          else
             message = "Twitter account is already activated"
          end
        else
          message = "Twitter account is not valid"
        end
        @rjs_message =  message
        find_twitter_account
        respond_to do |format|
          format.js
        end
      end
    rescue
       render_message("Twitter account is not valid")
    end
  end

  def remove_twitter_account
    @twitter_account = BackupSource.find(params[:id])
    @twitter_account.destroy
    
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
      current_user.backup_sources << @feed_url
      # @feed_url.reload.backup Reload to get user id and initiate backup!
      # Get paginated list of feeds, ordered by most recent
      @feed_urls = current_user.backup_sources.by_site(BackupSite::Blog).paginate(
        :page => params[:page], :per_page => 10, :order => 'created_at DESC')
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_url
    if f = current_user.backup_sources.find(params[:id].to_i)
      f.destroy
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
         if message != "activated" and message != "Twitter account is already activated"
           page.replace "rjs-message", :partial => "shared/rjs_message", :layout => false
           page["twitter-link"].removeClassName('twitter-active')
           page["twitter-link"].addClassName('twitter-btn')
           page.visual_effect :highlight, 'rjs-message'
         else
           @rjs_message =  ""
           page.replace "rjs-message", :partial => "shared/rjs_message", :layout => false
           page["twitter-link"].removeClassName('twitter-btn')
           page["twitter-link"].addClassName('twitter-active')
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
  
end
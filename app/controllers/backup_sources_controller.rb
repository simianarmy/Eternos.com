# $Id$

require 'twitter_backup'

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
    request_token = TwitterBackup.oauth_client.request_token(:oauth_callback => twitter_auth_backup_sources_url(:host => request.host))
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  end
  
  def twitter_auth
    begin
      if TwitterBackup.account_authenticated?(session[:request_token], 
        session[:request_token_secret],
        params[:oauth_verifier]
        )
        @access_token = TwitterBackup.access_token
        RAILS_DEFAULT_LOGGER.debug "Twitter access_token = #{@access_token.inspect}"
        backup_source = current_user.backup_sources.twitter.find_by_auth_token(@access_token.token)
        if backup_source.nil?
          # Try to get twitter screen name for backup source title
          backup_source = current_user.backup_sources.new(
            :backup_site_id => BackupSite.name_eq(BackupSite::Twitter).first.id,
            :title => TwitterBackup.screen_name || '',
            :auth_token => @access_token.token,
            :auth_secret => @access_token.secret
            )
          if backup_source.save
            backup_source.confirmed!
            current_user.completed_setup_step(2)            
            flash[:notice] = "Twitter account successfully saved"
          end
        else
          flash[:error] = "Twitter account is already activated"
        end
      else
        flash[:error] = "Twitter account is not valid"
      end
    rescue
       flash[:error] = "Unexpected error adding the Twitter account: " + $!
    end

    redirect_to account_setup_path
  end

  def og_twitter_auth
    begin
      if TwitterBackup.account_authenticated_httpauth?(params[:backup_source][:auth_login], params[:backup_source][:auth_password])  
        backup_source = current_user.backup_sources.twitter.find_by_auth_login(params[:backup_source][:auth_login])
        if backup_source.nil?
          backup_source = current_user.backup_sources.new(params[:backup_source].merge({
            :backup_site_id => backup_site.id
            }))
          if backup_source.save
            backup_source.confirmed!
            current_user.completed_setup_step(2)            
            flash[:notice] = "Twitter account successfully saved"
          end 
        else
          flash[:notice] = "Twitter account is already activated"
        end
      else
        flash[:error] = "Twitter account is not valid"
      end
    rescue
       flash[:error] = "Twitter account is not valid"
    end

    find_twitter_accounts # reload accounts list
    respond_to do |format|
      format.js
    end
  end
  
  
  def remove_twitter_account
    begin
      remove_account(BackupSite::Twitter, params[:id])
      flash[:notice] = "Twitter account removed"
    rescue
      flash[:error] = "Could not find twitter account to remove"
    end
    find_twitter_accounts
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
        flash[:notice] = "Feed sucessfully saved"
      else
        flash[:error] = @feed_url.errors.full_messages
      end
    rescue
      flash[:error] = "Unexpected error adding this feed!"
    end
    
    find_rss_accounts
    
    respond_to do |format|
      format.js
    end
  end 
  
  def remove_url
    begin
      remove_account(BackupSite::Blog, params[:id])
      flash[:notice] = "Feed removed"
    rescue
      flash[:error] = "Could not find rss account to remove"
    end
    find_rss_accounts
    find_rss_confirmed
    
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def find_twitter_accounts
    @twitter_accounts = current_user.backup_sources.twitter.paginate :page => params[:page], :per_page => 10
  end
  
  def find_twitter_confirmed
    @twitter_account   = current_user.backup_sources.twitter.first
    @twitter_confirmed = @twitter_account && @twitter_account.confirmed?
  end
  
  def find_rss_accounts
    @feed_urls = current_user.backup_sources.blog.paginate(
      :page => params[:page], :per_page => 10, :order => 'created_at DESC')
  end
  
  def find_rss_confirmed
    @rss_url = current_user.backup_sources.blog.first
    @rss_confirmed = @rss_url && @rss_url.confirmed?
  end
  
  def remove_account(type, id)
    current_user.backup_sources.by_site(type).find(id).destroy
  end
end
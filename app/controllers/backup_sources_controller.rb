# $Id$

require 'twitter_backup'
require 'google_backup'
#require 'linkedin2'
require 'nokogiri'

class BackupSourcesController < ApplicationController
  before_filter :login_required
  require_role "Member"

  ssl_allowed :add_twitter, :remove_twitter_account,
    :add_picasa, :remove_picasa_account,
    :add_feed_url, :remove_url, :picasa_auth, :twitter_auth,
    :add_linkedin, :remove_linkedin_account, :linkedin_callback

  def index
    @need_setup = current_user.need_backup_setup?
    respond_to do |format|
      format.js {
        render :json => {:need_setup => @need_setup}
      }
    end
  end

  # Redirects to Twitter's OAuth login page
  def add_twitter
    request_token = TwitterBackup::OAuth.oauth_client.request_token(
      :oauth_callback => twitter_auth_backup_sources_url(:host => request.host)
    )
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret

    respond_to do |format|
      format.html {
        redirect_to request_token.authorize_url
      }
    end
  end

  # Redirect's to Google's AuthSubRequest page
  def add_picasa
    client = GoogleBackup::Auth::Picasa.new(
      :callback_url => picasa_auth_backup_sources_url(:host => request.host))

    respond_to do |format|
      format.html {
        redirect_to client.authsub_url
      }
    end
  end
  
  def add_linkedin
    config = Linkedin2.load_config
    #@userID = '123' # ??
    consumer = Linkedin2::Consumer.new(config['consumer_key'], config['secret_key'], 
      :oauth_callback => linkedin_callback_backup_sources_url
    )
    session[:consumer] = consumer
    redirect_to consumer.request_token
  rescue Exception => e
    Rails.logger.error "Error in add_linkedin: #{e.class} #{e.message}"
    flash[:error] = "Unable to complete request!  Please try again or contact support."
    redirect_to account_setup_path
  end

  def linkedin_callback
    @oauth_verifier = params[:oauth_verifier]
    consumer = session[:consumer]
    consumer.access_token(@oauth_verifier.to_s)
    @access_token = consumer.get_access_token
    @secret_token = consumer.get_secret_access_token
    backup_source = current_user.backup_sources.linkedin.find_by_auth_token(@access_token)

    title = consumer.get_name
    Rails.logger.info "Linkedin returned name: #{title}"

    if backup_source.nil?
      # Try to get twitter screen name for backup source title
      backup_source = LinkedinAccount.new(
        :user_id => @current_user.id,
        :backup_site_id => BackupSite.find_by_name(BackupSite::Linkedin).id,
        :title =>  title,
        :auth_token => @access_token,
        :auth_secret => @secret_token
      )
      if backup_source.save
        backup_source.confirmed!
        current_user.completed_setup_step(1)
        flash[:notice] = "Linkedin account successfully added"
      end
    else
      # Stupid read-only activerecord workaround
      bs = LinkedinAccount.find(backup_source.id)
      bs.update_attribute(:title, title)
      flash[:notice] = "Linkedin account is already activated"
    end

    respond_to do |format|
      format.html {
        redirect_to account_setup_path
      }
    end
  end
  
  # Remove Linked In Account
  def remove_linkedin_account
    begin
      remove_account(BackupSite::Linkedin, params[:id])
      flash[:notice] = "Linked In account removed"
    rescue
      flash[:error] = "Could not find Linked In account to remove"
    end
    find_linkedin_accounts
    find_linkedin_confirmed

    respond_to do |format|
      format.js
    end
  end
  
  # Twitter OAuth authentication callback url
  def twitter_auth
    begin
      if TwitterBackup::OAuth.account_authenticated?(session[:request_token],
          session[:request_token_secret],
          params[:oauth_verifier]
        )
        @access_token = TwitterBackup::OAuth.access_token
        Rails.logger.debug "Twitter access_token = #{@access_token.inspect}"
        backup_source = current_user.backup_sources.twitter.find_by_auth_token(@access_token.token)
        if backup_source.nil?
          # Try to get twitter screen name for backup source title
          backup_source = current_user.backup_sources.new(
            :backup_site_id => BackupSite.find_by_name(BackupSite::Twitter).id,
            :title => TwitterBackup::OAuth.screen_name || '',
            :auth_token => @access_token.token,
            :auth_secret => @access_token.secret
          )
          if backup_source.save
            backup_source.confirmed!
            current_user.completed_setup_step(1)
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

    respond_to do |format|
      format.html {
        redirect_to (current_subdomain == 'vault') ? account_backups_path : account_setup_path
      }
    end
  end

  # Google AuthSub authentication callback url
  def picasa_auth
    # Need access to GData client object in order to upgrade token using session
    picasa_client = GoogleBackup::Auth::Picasa.new(:auth_token => params[:token])
    gdata_client = picasa_client.client

    begin
      # Upgrade single-use token to permanent token
      if session[:token] = gdata_client.auth_handler.upgrade()
        gdata_client.authsub_token = auth_token = session[:token]
        Rails.logger.debug "AuthSub token upgraded to #{auth_token}"

        # Fetch the account title from google, using new client object
        info_client = GoogleBackup::Auth::Picasa.new :auth_token => auth_token
        title = info_client.account_title
        Rails.logger.debug "Account title from google: #{title}"

        #Create new backup source
        backup_source = current_user.backup_sources.picasa.find_by_title(title)
        if backup_source.nil?
          backup_source = PicasaWebAccount.new(:user_id => current_user.id,
            :backup_site_id => BackupSite.find_by_name(BackupSite::Picasa).id,
            :auth_token => auth_token,
            :title => title
          )
          if backup_source.save
            # This triggers backup job
            backup_source.confirmed!
            current_user.completed_setup_step(1)
            flash[:notice] = "#{PicasaWebAccount.display_title} account successfully saved"
          end
        else
          flash[:error] = "#{PicasaWebAccount.display_title} account is already activated"
        end
      else
        flash[:error] = "Invalid #{PicasaWebAccount.display_title} account credentials"
      end
    rescue
      flash[:error] = "Unexpected error adding the #{PicasaWebAccount.display_title} account"
      Rails.logger.error "Exception in picasa_auth: " + $!
    end

    respond_to do |format|
      format.html {
        redirect_to (current_subdomain == 'vault') ? account_backups_path : account_setup_path
      }
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

  def remove_picasa_account
    @id = params[:id]
    begin
      if backup_source = current_user.backup_sources.picasa.find(@id)
        # Revoke GData authorization
        picasa_client = GoogleBackup::Auth::Picasa.new(:auth_token => backup_source.auth_token)
        gdata_client = picasa_client.client
        gdata_client.auth_handler.revoke()

        remove_account(BackupSite::Picasa, params[:id])
        flash[:notice] = "#{PicasaWebAccount.display_title} account removed"
      else
        flash[:error] = "Could not find #{PicasaWebAccount.display_title} account to remove"
      end
    rescue
      flash[:error] = "Unexpected error removing the #{PicasaWebAccount.display_title} account"
    end
    @picasa_accounts = current_user.backup_sources.picasa

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
        current_user.completed_setup_step(1)
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

  protected


  private

  def find_twitter_accounts
    @twitter_accounts = current_user.backup_sources.twitter
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

  def find_linkedin_accounts
    @linkedin_accounts = current_user.backup_sources.linkedin
  end

  def find_linkedin_confirmed
    @linkedin_account   = current_user.backup_sources.linkedin.first
    @linkedin_confirmed = @linkedin_account && @linkedin_account.confirmed?
  end

  def remove_account(type, id)
    # Soft delete backup source?
    #current_user.backup_sources.by_site(type).find(id).update_attribute(:deleted_at, true)
    current_user.backup_sources.by_site(type).find(id).destroy
  end
end

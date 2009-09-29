# $Id$

require 'facebook_desktop'

class FacebookBackupController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :load_facebook_desktop
  before_filter :load_session
  before_filter :load_backup_source
  layout 'dialog'
  
  #rescue_from Facebooker::Session::SessionExpired, :with => :create_new_session
  
  def new
    # Make sure user not already authenticated
    if current_user.authenticated_for_facebook_desktop?
      begin
        # Login with user's saved fb session and try a facebooker operation to 
        # test for session validity
        current_user.facebook_session_connect @session        
        if @session.verify && @session.secured? && !@session.expired?
          redirect_to :action => :permissions
          return
        end
      rescue
        # No problem they just need to login again
        RAILS_DEFAULT_LOGGER.debug "Facebook connect failed on authenticated user!"
      end
    end
    
    begin
      @auth_token = @session.auth_token
      @login_url = @session.login_url
    rescue Facebooker::Session::SessionExpired
      load_facebook_desktop
      load_session
      retry
    end
  end
  
  def authenticate
    begin
      @session.auth_token = params[:auth_token]
      @session.secure_with_session_secret!
      
      # Save facebook uid, session, & secret key for headless login
      if @session.secured? && !@session.expired? && (user = @session.user) 
        current_user.update_attribute(:facebook_uid, user.id)
        current_user.set_facebook_session_keys(@session.session_key, @session.secret_from_session)
        flash[:notice] = "Login successful!"
        redirect_to :action => :permissions
      else
        raise "Unable to secure login session"
      end
    rescue Exception => e
      flash[:error] = "Authentication error in Facebook app: #{e.to_s}"
      redirect_to :action => :new
    end
  end
  
  def permissions
    # Get facebook auth data for the app
    current_user.facebook_session_connect @session
    unless @session.secured?
      flash[:error] = "Unable to log you in to Facebook App: connect method failed.  Please Try Again"
      redirect_to :action => :new
      return
    end
    @offline_url = @session.permission_url(:offline_access) unless check_permission(:offline_access)
    @stream_url = @session.permission_url(:read_stream) unless check_permission(:read_stream)
    
    respond_to do |format|
      format.html {
        # Turn off confirmed flag if insufficient permissions
        if @backup_source.confirmed? && (@offline_url || @stream_url)
          @backup_source.update_attribute(:auth_confirmed, false)
        end
      }
      format.js {
        render :json => {:offline => @offline_url.nil?, :stream => @stream_url.nil?}
      }
    end
  end
  
  # For js ajax requests to check user's auth status
  # Wonder if it will work w/out cookies
  def check_auth
    auth = begin
      current_user.facebook_session_connect @session
      check_permission(:offline_access) && check_permission(:read_stream)
    rescue
      false
    end
    
    if auth
      current_user.completed_setup_step(2)
      # Run backup & update confirmation status on 1st check
      @backup_source.confirmed! if !@backup_source.confirmed?
    end
    
    respond_to do |format|
      format.js {
        render :json => {:authenticated => auth}.to_json
      }
    end
  end
    
  # Called by Facebook after Desktop app authentication + authorization. 
  # FB returns session values in session param as JSON object.  
  # Save:
  # session_key
  # secret
  # uid
  
  def authorized
    RAILS_DEFAULT_LOGGER.debug "#{self.class.to_s}:authorized called by Facebook:\n"
    fb_session = ActiveSupport::JSON.decode(params[:session])
    RAILS_DEFAULT_LOGGER.debug "Session json = " + fb_session.inspect
    
    if fb_session['uid']
      current_user.update_attribute(:facebook_uid, fb_session['uid'])
      current_user.set_facebook_session_keys(fb_session['session_key'], fb_session['secret'])
      flash[:notice] = "Facebook account authorized for backup!"

      current_user.completed_setup_step(2)
      # Run backup & update confirmation status on 1st check
      @backup_source.confirmed! if !@backup_source.confirmed?
    end
    
    respond_to do |format|
      format.html {
        redirect_to account_setup_path    
      }
      format.js {
        render :nothing => true, :status => 200
      }
    end
  end
  
  def cancel
    RAILS_DEFAULT_LOGGER.info "#{self.to_s}:cancel called by Facebook:\n"
    
    # Send Facebook revoke authorization 
    current_user.facebook_session_connect @session
    @session.post('facebook.auth.revokeAuthorization', :uid => @session.user.id)
    
    # Remove session keys
    @backup_source.update_attribute(:auth_confirmed, false)
    current_user.set_facebook_session_keys(nil, nil)
    
    flash[:notice] = "Facebook account removed from Eternos Backup."
    
    respond_to do |format|
      format.html {
        redirect_to account_setup_path    
      }
      format.js {
        render :nothing => true, :status => 200
      }
    end
  end
  
  def canvas
    render :nothing => true, :status => 200
  end
  
  def destroy
    @backup_source.update_attribute(:auth_confirmed, false)
    current_user.set_facebook_session_keys(nil, nil)

    flash[:notice] = "Successfully removed from Facebook backup."
    respond_to do |format|
      format.html { redirect_to member_home_path }
      format.js
    end
  end
  
  private
  
  def create_new_session
    load_facebook_desktop
    load_session
  end
  
  def load_session
    @session = Facebooker::Session.current
  end
  
  def load_backup_source
    @backup_source = current_user.backup_sources.facebook.first 
    @backup_source ||= current_user.backup_sources.create(
      :backup_site => BackupSite.find_by_name(BackupSite::Facebook))
  end
  
  # Helper for ajax permission check methods
  def check_permission(perm)
    @session.user.has_permission?(perm)
  rescue
    false
  end
end

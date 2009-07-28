# $Id$

require 'facebook_desktop'

class FacebookBackupController < ApplicationController
  before_filter :login_required, :except => [:authorized, :removed]
  require_role "Member", :for_all_except  => [:authorized, :removed]
  before_filter :load_facebook_desktop
  before_filter :load_session
  before_filter :load_backup_source, :except => [:authorized, :removed]
  layout 'dialog'
  
  #rescue_from Facebooker::Session::SessionExpired, :with => :create_new_session
  
  def new
    # Make sure user not already authenticated
    if current_user.authenticated_for_facebook_desktop?
      begin
        current_user.facebook_session_connect @session
        @session.secure_with_session_secret!

        if @session.secured? && !@session.expired?
          redirect_to :action => :permissions
          return
        end
      rescue
        # No problem they just need to login again
        RAILS_DEFAULT_LOGGER.debug "Facebook connect failed on authenticated user!"
        @session = load_facebook_desktop
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
    @offline_url = @session.permission_url(:offline_access) unless @session.user.has_permission?(:offline_access)
    @stream_url = @session.permission_url(:read_stream) unless @session.user.has_permission?(:read_stream)
  end
  
  # For js ajax requests to check user's auth status
  # Wonder if it will work w/out cookies
  def check_auth
    begin
      current_user.facebook_session_connect @session
      auth = @session.user.has_permission?(:offline_access) && @session.user.has_permission?(:read_stream)
    rescue
      auth = false
    end
    
    # Run backup & update confirmation status on 1st check
    if auth && !@backup_source.confirmed?
      @backup_source.confirmed!
    end
    respond_to do |format|
      format.js {
        render :json => {:authenticated => auth}.to_json
      }
    end
  end
  
  # Called by Facebook after 1st time app authorization.  Passes a bunch of fb_sig_* values.
  # May be definitive way to ensure proper authentication, replacing the authenticate action.
  # Problem is, no Rails session info passed so can't lookup user to save facebook info!
  # For now, simply save params to log.  Data might be parsed separately if needed.
  
  # Important params:
  # fb_sig_user: User's Facebook ID
  # fb_sig_authorize: "1" = authorized
  # fb_sig_ss: User's session secret
  def authorized
    RAILS_DEFAULT_LOGGER.info "#{self.to_s}:authorized called by Facebook:\n"
    RAILS_DEFAULT_LOGGER.info params.inspect
    
    render :nothing => true, :status => 200
  end
  
  def removed
    RAILS_DEFAULT_LOGGER.info "#{self.to_s}:removed called by Facebook:\n"
    RAILS_DEFAULT_LOGGER.info params.inspect
    
    render :nothing => true, :status => 200
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
    @backup_source = current_user.backup_sources.by_site(BackupSite::Facebook).first 
    @backup_source ||= current_user.backup_sources.create(
      :backup_site => BackupSite.find_by_name(BackupSite::Facebook))
  end
end

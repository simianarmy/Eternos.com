# $Id$

require 'facebook_desktop'

class FacebookBackupController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :load_facebook_desktop
  before_filter :load_session
  before_filter :load_backup_source, :except => [:new]
  
  def new
    @auth_token = @session.auth_token
    @login_url = @session.login_url
  end
  
  def authenticate
    begin
      @session.auth_token = params[:auth_token]
      @session.secure_with_session_secret!
      # Save facebook uid, session, & secret key for headless login

      if @session.secured? && (user = @session.user)
        current_user.update_attribute(:facebook_uid, user.id)
        current_user.set_facebook_session_keys(@session.session_key, @session.secret_from_session)
        @backup_source.confirmed!
        flash[:notice] = "Login successful!"
        redirect_to :action => :permissions
      else
        raise "Unable to secure login @session"
      end
    rescue Exception => e
      flash[:error] = "Authentication error in Facebook app: #{e.to_s}"
      redirect_to :action => :new
    end
  end
  
  def permissions
    # Get facebook auth data for the app
    @session.connect(current_user.facebook_session_key, current_user.facebook_id, nil, current_user.facebook_secret_key)
    unless @session.secured?
      flash[:error] = "Unable to log you in to Facebook App: connect method failed.  Please Try Again"
      redirect_to :action => :new
      return
    end
    @offline_url = @session.permission_url(:offline_access) unless @session.user.has_permission?(:offline_access)
    @stream_url = @session.permission_url(:read_stream) unless @session.user.has_permission?(:read_stream)
  end
  
  def authorized
  end
  
  def removed
  end
  
  def canvas
  end
  
  private
  
  def load_session
    @session = Facebooker::Session.current
  end
  
  def load_backup_source
    @backup_source = current_user.backup_sources.by_site(BackupSite::Facebook).first
    @backup_source ||= current_user.backup_sources.create(
      :backup_site => BackupSite.find_by_name(BackupSite::Facebook),
      :auth_login => '')
  end
end

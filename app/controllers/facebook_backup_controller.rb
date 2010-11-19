# $Id$

require 'facebook_desktop'

class FacebookBackupController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :create_new_session
  before_filter :load_backup_source
  layout 'dialog'
    
  #rescue_from Facebooker::Session::SessionExpired, :with => :create_new_session
  
  # For js ajax requests to check user's auth status
  # Wonder if it will work w/out cookies
  def check_auth
    auth = has_permissions?
    
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
    Rails.logger.debug "#{self.class.to_s}:authorized called by Facebook:\n"
    begin
      fb_session = ActiveSupport::JSON.decode(params[:session])
      Rails.logger.debug "Session json = " + fb_session.inspect
    
      if fb_session['uid']
        current_user.update_attribute(:facebook_uid, fb_session['uid'])
        current_user.set_facebook_session_keys(fb_session['session_key'], fb_session['secret'])
        if has_permissions?
          save_authorization 
          flash[:notice] = "Facebook account authorized for backup!"
        else
          flash[:error] = "You must grant ALL requested permissions to the Eternos Backup application."
        end
      end
    rescue Exception => e
      Rails.logger.warn "Exception in FacebookBackupController:authorized: " + e.message
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
    revoke_permissions
    
    # Remove session keys
    current_user.set_facebook_session_keys(nil, nil)
    @backup_source.update_attribute(:auth_confirmed, false)
    
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
  
  # What is this for?
  def canvas
    render :nothing => true, :status => 200
  end
  
  def destroy
    revoke_permissions
    
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
    # TODO: LOAD FACEBOOK ACCOUNT USING THE FACEBOOK SESSION KEY!
    @backup_source = current_user.backup_sources.facebook.find_by_auth_login(@session.user.id)
    @backup_source ||= FacebookAccount.new(:user_id => current_user.id,
      :backup_site_id => BackupSite.find_by_name(BackupSite::Facebook).id,
      :auth_login => @session.user.id
    )
  end
  
  def save_authorization
    # Not the right place for this but oh well
    current_user.completed_setup_step(2)
    # Run backup & update confirmation status on 1st check
    @backup_source.confirmed!
  end
  
  # Checks if user has required facebook permissions
  def has_permissions?
    begin
      current_user.facebook_session_connect @session
      @session.user.has_permissions? FacebookDesktopApp.backup_permissions
    rescue
      false
    end
  end
  
  # Helper for Facebook permission check method
  def check_permission(perm)
    @session.user.has_permission?(perm)
  rescue
    false
  end
  
  def revoke_permissions
    # Send Facebook revoke authorization 
    current_user.facebook_session_connect @session
    @session.post('facebook.auth.revokeAuthorization', :uid => @session.user.id)
  end
end

# $Id$

require 'facebook_desktop'
require 'facebook_account_manager'

class FacebookBackupController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :set_facebook_desktop_session
  before_filter :load_backup_source, :except => [:authorized]
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
    # If perms = nil, app authorization was not 'allowed'
    if params[:session].nil?
      Rails.logger.error "Facebook backup not authorized! #{params.inspect}"
      flash[:error] = "The Eternos Backup Facebook app was not authorized.  You must press 'Allow' in the popup dialog."
    else
      begin
        fb_session = ActiveSupport::JSON.decode(params[:session])
        Rails.logger.info "Session json = " + fb_session.inspect
    
        if fb_session['uid']
          # DEPRECATED:
          #current_user.update_attribute(:facebook_uid, fb_session['uid'])
          #current_user.set_facebook_session_keys(fb_session['session_key'], fb_session['secret'])
          load_facebook_account_backup_source(fb_session['uid'])
          
          # Save session key & secret to facebook account record
          if fb_session['session_key'] && fb_session['secret']
            @backup_source.set_facebook_session_keys(fb_session['session_key'], fb_session['secret'])
          else  
            @backup_source.save! if @backup_source.new_record?
          end
          # Don't need to post hasAppPermission here, just check session
          if fb_session['expires'] == 0
            save_authorization 
            flash[:notice] = "Your Facebook account has authorized Eternos Backup!"
          else
            flash[:error] = "You must grant ALL requested permissions to the Eternos Backup application."
          end
        else
          Rails.logger.error "*** NO UID IN SESSION!"
        end
      rescue Exception => e
        Rails.logger.warn "Exception in FacebookBackupController:authorized: " + e.message
      end
    end
    respond_to do |format|
      format.html {
        redirect_to account_setup_url(:protocol => 'https')
      }
      format.js {
        render :nothing => true, :status => 200
      }
    end
  end
  
  def cancel
    revoke_permissions
    
    # Remove session keys
    @backup_source.reset_authorization
    
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
    
    @backup_source.reset_authorization

    flash[:notice] = "Successfully removed from Facebook backup."
    respond_to do |format|
      format.html { redirect_to member_home_path }
      format.js
    end
  end
  
  private
  
  def load_backup_source
    begin
      # Load appropriate facebook account for this user
      login_facebook_account
      # Load or create backup source corresponding to this facebook account
      load_facebook_account_backup_source(@facebook_session.user.id)
    rescue Facebooker::Session::MissingOrInvalidParameter => e
      flash[:error] = "There was a problem obtaining your Facebook account session: #{e.message}"
      redirect_to account_setup_path
      return
    end
  end
  
  def load_facebook_account_backup_source(fb_id)
    sources = FacebookAccount.auth_login_eq(fb_id)
    if sources.any?
      # If we match more than one backup source for an account id - we gotta find the right user!
      # If there is no user...use most recent?
      if sources.size > 1
        if @current_user
          @backup_source = sources.detect {|s| s.user_id == @current_user.id }
        else
          raise "ERROR!  More than one Facebook account with the same ID!"
        end
      else
        @backup_source = sources.first
      end
    end
    # Create new source if none found
    @backup_source ||= FacebookAccount.new(:user_id => current_user.id,
      :backup_site_id => BackupSite.find_by_name(BackupSite::Facebook).id,
      :auth_login => fb_id)
  end
  
  def save_authorization
    # Not the right place for this but oh well
    current_user.completed_setup_step(2)
    # Run backup & update confirmation status on 1st check
    @backup_source.confirmed!
    @backup_source.reload # Make sure views can see updates
  end
  
  # Checks if user has required facebook permissions
  def has_permissions?
    begin
      login_facebook_account
      @facebook_session.user.has_permissions? FacebookDesktopApp.backup_permissions
    rescue
      false
    end
  end
  
  # Helper for Facebook permission check method
  def check_permission(perm)
    @facebook_session.user.has_permission?(perm)
  rescue
    false
  end
  
  def revoke_permissions
    # Send Facebook revoke authorization 
    begin
      fb_id = @facebook_session.user.id
      Rails.logger.error "User #{current_user.id} is removing Facebook Backup account #{fb_id}"
      @facebook_session.post('facebook.auth.revokeAuthorization', :uid => fb_id)
    rescue Exception => e
      flash[:error] = "We encountered an error removing our app from your Facebook account (#{e.message}).  Please try again."
    end
  end
  
  # Use the facebook session object to login the correct facebook account based on the 
  # user's facebook id setting or a passed parameter
  def login_facebook_account
    Rails.logger.debug "In login_facebook_account"
    FacebookAccountManager.login_with_session(@facebook_session, current_user, 
      params[:account_id] || current_user.facebook_id)
  end
end

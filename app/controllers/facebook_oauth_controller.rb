# FacebookOauth controller
# Uses Mogli gem for Facebook's new OAuth authentication

class FacebookOauthController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  ssl_required :all
  
  def new
    session[:at] = nil
    redirect_to authenticator.authorize_url(:scope => FacebookBackup.all_permissions.join(','), :display => 'page')
  end
  
  def create    
    Rails.logger.debug "#{self.class.to_s}:create called by Facebook OAuth"
    
    begin
      client = Mogli::Client.create_from_code_and_authenticator(params[:code], authenticator)
      session[:at] = token = client.access_token
    
      # If perms = nil, app authorization was not 'allowed'
      if token.nil?
        Rails.logger.error "Facebook backup not authorized! #{params.inspect}"
        flash[:error] = "The Eternos Backup Facebook app was not authorized.  You must press 'Allow' in the popup dialog."
      else
        fb_user = Mogli::User.find("me", client)  
        bs = load_facebook_account_backup_source(current_user, fb_user.id)
        # Save access token to facebook account record
        if token
          bs.update_attributes(:auth_token => token, :title => fb_user.name, :auth_login => fb_user.id)
        else  
          bs.save! if bs.new_record?
        end
        save_authorization 
        flash[:notice] = "Your Facebook account has authorized Eternos Backup!"
      end
    rescue Exception => e
      Rails.logger.warn "Exception in FacebookBackupController:authorized: " + e.message
      flash[:error] = "An unexpected error was encountered!  Please contact support<br/>" <<
        "#{e.class} #{e.message}"
    end
    
    respond_to do |format|
      format.html {
        redirect_to account_backups_path
      }
      format.js {
        render :nothing => true, :status => 200
      }
    end
  end
  
  def show
    redirect_to new_facebook_oauth_path and return unless session[:at]
    #user = Mogli::User.find("me", Mogli::Client.new(session[:at]))
  end
  
  def cancel
    # Remove session keys
    if bs = load_facebook_account_backup_source(current_user, params[:account_id])
      bs.reset_authorization
    end
    flash[:notice] = "Your Facebook account will no longer be backed up.  Click 'Enable' to reauthorize it anytime."
    
    respond_to do |format|
      format.html {
        redirect_to account_backups_path    
      }
      format.js {
        render :nothing => true, :status => 200
      }
    end
  end
  
  def destroy
    # Remove session keys
    if bs = load_facebook_account_backup_source(current_user, params[:account_id])
      bs.reset_authorization
      # Don't remove yet.  They may change their minds
      bs.touch(:deleted_at)
    end
    flash[:notice] = "Your Facebook account and all its data has been disabled." <<
      "  All of its related data will be removed from our systems within 24 hours."

    respond_to do |format|
      format.html { redirect_to account_backups_path }
      format.js
    end
  end
  
  def authenticator
    fb_app = load_facebook_app
    @authenticator ||= Mogli::Authenticator.new(fb_app.app_id, 
      fb_app.app_secret,
      facebook_oauth_callback_url)
  end

  private

  # Helper to read vault facebook app settings.  Will be moved to lib once I figure out 
  # organization
  def load_facebook_app
    FacebookBackup::OpenGraphApp.new(:vault)
  end
    
  def save_authorization
    # Not the right place for this but oh well
    current_user.completed_setup_step(2)
    # Run backup & update confirmation status on 1st check
    @backup_source.confirmed!
    @backup_source.reload # Make sure views can see updates
  end
  
  def load_facebook_account_backup_source(user, account_id)
    # Avoid readonly trap, load from id once found
    if bs = user.backup_sources.facebook.find_by_auth_login(account_id)
      @backup_source = FacebookAccount.find(bs.id)
    end
    # Create new source if none found
    @backup_source ||= FacebookAccount.new(:user_id => user.id,
      :backup_site_id => BackupSite.find_by_name(BackupSite::Facebook).id,
      :auth_login => account_id)
  end
end
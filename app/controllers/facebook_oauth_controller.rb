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
        bs = load_facebook_account_backup_source(current_user)
        fb_user = Mogli::User.find("me", client)  
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
    user = Mogli::User.find("me", Mogli::Client.new(session[:at]))
    @user = user
    @posts = user.posts
  end
  
  def authenticator
    @authenticator ||= Mogli::Authenticator.new('193664657324382', 
                                         '58413dcf7978877179669e798643b6c4', 
                                         facebook_oauth_callback_url)
  end
  
  private
  
  def save_authorization
    # Not the right place for this but oh well
    current_user.completed_setup_step(2)
    # Run backup & update confirmation status on 1st check
    @backup_source.confirmed!
    @backup_source.reload # Make sure views can see updates
  end
  
  def load_facebook_account_backup_source(user)
    sources = user.backup_sources.facebook
    if sources.any?
      # If we match more than one backup source for an account id - we gotta find the right user!
      # If there is no user...use most recent?
      @backup_source = sources.detect {|s| s.user_id == user.id }
    end
    # Create new source if none found
    @backup_source ||= FacebookAccount.new(:user_id => user.id,
      :backup_site_id => BackupSite.find_by_name(BackupSite::Facebook).id)
  end
end
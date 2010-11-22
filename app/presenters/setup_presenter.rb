# $Id$

# Presenter class for account_setup & account_settings controller views
# Contains common methods for both controllers

require 'facebook_account_manager'

class SetupPresenter < AccountPresenter
  attr_accessor :active_step, :completed_steps, :any_activated,
    :facebook_account, :facebook_confirmed, :facebook_user, :facebook_pic, :fb_login_url,
    :twitter_accounts, :twitter_account, :twitter_confirmed,
    :picasa_accounts, :picasa_account, :picasa_confirmed,
    :feed_urls, :feed_url, :rss_url, :rss_confirmed,
    :email_accounts, :current_gmail, :gmail_confirmed
   
  include BackupSourceActivation
  
  def load_backup_sources
    get_activations(@user)
  end
  
  def load_facebook_user_info
    # Also get facebook profile data
    if @facebook_confirmed
      begin
        Rails.logger.debug "FETCHING FACEBOOK USER INFO.."
        FacebookAccountManager.login_with_session(@fb_session, @user, 
          @user.facebook_id)

        if @fb_session.verify_permissions
          @fb_session.user.populate(:pic_small, :name) 
          @facebook_user = @fb_session.user.name
          @facebook_pic = @fb_session.user.pic_small
        else
          Rails.logger.error "BACKUP SOURCE CONFIRMED, BUT verify_permissions FALSE!"
          @facebook_confirmed = false
        end
      rescue Facebooker::Session::SessionExpired, Facebooker::Session::IncorrectSignature => e
        RAILS_DEFAULT_LOGGER.error "Error in load_facebook_user_info: #{e.class} #{e.message}"
        @facebook_confirmed = false
        @facebook_user = @facebook_pic = nil
      rescue Exception => e
        RAILS_DEFAULT_LOGGER.error "Error in load_facebook_user_info: #{e.class} #{e.message}"
      end
    end
  end
  
  def create_fb_login_url(request)
    # Desktop login url 
    # Using url described on http://wiki.developers.facebook.com/index.php/Authorization_and_Authentication_for_Desktop_Applications#Prompting_for_Permissions
    @fb_login_url = @fb_session.login_url_with_perms(
      :next => authorized_facebook_backup_url(:host => request.host), 
      :next_cancel => cancel_facebook_backup_url(:host => request.host)
      )
  end
end
  

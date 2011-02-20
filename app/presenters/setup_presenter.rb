# $Id$

# Presenter class for account_setup & account_settings controller views
# Contains common methods for both controllers

require 'facebook_account_manager'

class SetupPresenter < AccountPresenter
  attr_accessor :active_step, :completed_steps, :any_activated,
    :facebook_account, :facebook_confirmed, :facebook_user, :facebook_pic, :fb_login_url,
    :facebook_accounts, 
    :twitter_accounts, :twitter_account, :twitter_confirmed,
    :picasa_accounts, :picasa_account, :picasa_confirmed,
    :feed_urls, :feed_url, :rss_url, :rss_confirmed,
    :email_accounts, :current_gmail, :gmail_confirmed
   
  include BackupSourceActivation
  
  def load_backup_sources
    get_activations(@user)
  end
  
  def load_facebook_user_info
    # Also get all facebook accounts' profile data to display in setup list
    if @facebook_confirmed
      begin
        Rails.logger.debug "FETCHING FACEBOOK ACCOUNT USERNAMES.."
        @facebook_accounts.each do |fb|
          Rails.logger.debug "fetching name for account #{fb.account_id}"
          FacebookAccountManager.login_with_session(@fb_session, @user, 
          fb.account_id)

          if @fb_session.verify_permissions
            @fb_session.user.populate(:pic_small, :name) 
            fb.title = @fb_session.user.name
            fb.save(false)
          else
            @facebook_confirmed = false
            @facebook_user = @facebook_pic = nil
          end
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
  
end
  

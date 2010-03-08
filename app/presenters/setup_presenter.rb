# $Id$

# Presenter class for account_setup & account_settings controller views
# Contains common methods for both controllers

class SetupPresenter < AccountPresenter
  attr_accessor :active_step, :completed_steps, 
    :facebook_account, :facebook_confirmed, :facebook_user, :facebook_pic, :fb_login_url,
    :twitter_accounts, :twitter_account, :twitter_confirmed,
    :picasa_accounts, :picasa_account, :picasa_confirmed,
    :feed_urls, :feed_url, :rss_url, :rss_confirmed,
    :email_accounts, :current_gmail, :gmail_confirmed
   
  include BackupSourceActivation
  
  def load_backup_sources
    get_activations(@user)
    
    # Also get facebook profile data
    if @facebook_confirmed
      begin
        user.facebook_session_connect @fb_session
        @fb_session.user.populate(:pic_small, :name) if @fb_session.verify
        @facebook_user = @fb_session.user.name
        @facebook_pic = @fb_session.user.pic_small
      rescue Facebooker::Session::SessionExpired => e
        RAILS_DEFAULT_LOGGER.error "load_backup_sources: #{e.class} #{e.message}"
      rescue Exception => e
        RAILS_DEFAULT_LOGGER.error "load_backup_sources: #{e.class} #{e.message}"
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
  

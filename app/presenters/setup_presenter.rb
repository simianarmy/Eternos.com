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
   
  def create_fb_login_url(request)
    # Desktop login url 
    # Using url described on http://wiki.developers.facebook.com/index.php/Authorization_and_Authentication_for_Desktop_Applications#Prompting_for_Permissions
    @fb_login_url = @fb_session.login_url_with_perms(
      :next => authorized_facebook_backup_url(:host => request.host), 
      :next_cancel => cancel_facebook_backup_url(:host => request.host)
      )
  end
  
  def load_backup_sources
    backup_sources = @user.backup_sources
    if backup_sources.any?
      if @facebook_account = backup_sources.facebook.first
        if @facebook_confirmed = @facebook_account.confirmed?
          begin
            @user.facebook_session_connect @fb_session
            @fb_session.user.populate(:pic_small, :name) if @fb_session.verify
            @facebook_user = @fb_session.user.name
            @facebook_pic = @fb_session.user.pic_small
          rescue Facebooker::Session::SessionExpired
            # What to do ??
          end
        end
      else
        @facebook_confirmed = false
      end
      @twitter_accounts = backup_sources.twitter
      @twitter_account   = @twitter_accounts.first
      @twitter_confirmed = @twitter_accounts && @twitter_accounts.any? {|t| t.confirmed?}
      
      @picasa_accounts = backup_sources.picasa
      @picasa_account   = @picasa_accounts.first
      @picasa_confirmed = @picasa_accounts && @picasa_accounts.any? {|t| t.confirmed?}
      
      @feed_urls = backup_sources.blog
      @feed_url = FeedUrl.new
      @rss_confirmed = @feed_urls && @feed_urls.any? {|t| t.confirmed?}
      
      @email_accounts = @user.backup_sources.gmail
      @current_gmail = @email_accounts.first
      @gmail_confirmed = @email_accounts && @email_accounts.any? {|t| t.confirmed?}
    end
  end
end
  

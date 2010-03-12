# $Id$
#
#
# Presenter Decorators

# Decorates presenter with backup sources data

module BackupSourceActivation
  # Saves all backup sources, first instance of each, and activation status for each
  
  def get_activations(user)
    backup_sources = user.backup_sources
    if backup_sources.any?
      if @facebook_account = backup_sources.facebook.first
        @facebook_confirmed = @facebook_account.confirmed?
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
    
      @email_accounts = backup_sources.gmail
      @current_gmail = @email_accounts.first
      @gmail_confirmed = @email_accounts && @email_accounts.any? {|t| t.confirmed?}
      
      @any_activated = @facebook_confirmed || @twitter_confirmed || @picasa_confirmed || @rss_confirmed || @gmail_confirmed
    end
  end
end

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

module BackupSourceHistory
  
  def get_data_counts(user)
    returning Hash.new({:size => 0, :photos => 0, :videos => 0, :emails => 0, 
      :tweets => 0, :fb => 0, :rss => 0, :total => 0}) do |data|
      data[:albums] = user.photo_albums.size
      data[:photos] = user.contents.photos.count
      data[:videos] = user.contents.all_video.count
      data[:audio] = user.contents.all_audio.count
      data[:tweets] = user.activity_stream.items.twitter.count
      data[:fb] = user.activity_stream.items.facebook.count
      data[:rss] = FeedEntry.belonging_to_user(user.id).count
      data[:emails] = BackupEmail.belonging_to_user(user.id).count
      data[:total] = data.values.sum
    end
  end
end
  
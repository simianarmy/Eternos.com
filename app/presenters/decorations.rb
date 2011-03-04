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
      # Limit to one fb account per user for now...
      @facebook_accounts = FacebookAccountManager.facebook_accounts_for(user)
      @facebook_account = @facebook_accounts.first
      @facebook_confirmed = @facebook_accounts && @facebook_accounts.any? { |t| t.confirmed? }
      
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
      
      @linkedin_accounts = backup_sources.linkedin
      @current_linkedin = @linkedin_accounts.first
      @linkedin_confirmed = @linkedin_accounts && @linkedin_accounts.any? {|t| t.confirmed?}
      
      @any_activated = @facebook_confirmed || @twitter_confirmed || @picasa_confirmed || @rss_confirmed || @gmail_confirmed || @linkedin_confirmed
    end
  end
end

module BackupSourceHistory
  
  def get_data_counts(user)
    returning Hash.new(0) do |data|
      data[:albums] = user.photo_albums.size
      data[:photos] = user.contents.photos.count
      data[:videos] = user.contents.all_video.count
      data[:audio] = user.contents.all_audio.count
      data[:tweets] = user.activity_stream.items.twitter.count
      data[:fb] = user.activity_stream.items.facebook.count
      data[:media_comments] = Comment.count(:joins => "INNER JOIN contents ON contents.id = comments.commentable_id AND comments.commentable_type = 'Content'", 
        :conditions => {'contents.user_id' => user.id})
      data[:stream_comments] = Comment.count(:joins => "INNER JOIN activity_stream_items ON activity_stream_items.id = comments.commentable_id 
        AND comments.commentable_type = 'ActivityStreamItem' 
        INNER JOIN activity_streams ON activity_streams.id = activity_stream_items.activity_stream_id",
        :conditions => {'activity_streams.id' => user.activity_stream.id})
      data[:rss] = FeedEntry.belonging_to_user(user.id).count
      data[:emails] = BackupEmail.belonging_to_user(user.id).count
      data[:fb_messages] = user.backup_sources.facebook.map{|bs| bs.message_threads.map(&:message_count).sum }.sum
      data[:total] = data.values.sum
      data[:total_comments] = data[:stream_comments] + data[:media_comments]
      data[:last_backup_finished_at] = user.backup_state.last_backup_finished_at  if user.backup_state
    end
  end
end
  
# $Id$

# BackupSource STI class child

class FeedUrl < BackupSource
  has_one :feed, :foreign_key => 'backup_source_id'
  
  validates_presence_of :rss_url, :message => "Please enter a RSS feed URL"
  validates_uniqueness_of :rss_url, :scope => :user_id, :on => :create, :message => "Feed has already been saved"
  validate :validate_feed
  
  # Create Feed with feed metadata in @feed 
  after_create :save_feed
  
  def auth_required?
    !auth_login.blank? || !auth_password.blank?
  end
  
  private
  
  def validate_feed
    unless self.rss_url.blank?
      begin
        @feed_info = Feedzirra::Feed.fetch_and_parse(self.rss_url, :timeout => 30,
          :on_success => lambda { self.auth_confirmed = true },
          :on_failure => lambda { errors.add(:rss_url, "Invalid RSS feed")
          } )
      rescue Exception => e
        errors.add(:rss_url, "Invalid RSS feed (could not verify contents)")
      end
    end
  end
  
  def save_feed
    create_feed(:title => @feed_info.title.sanitize, 
      :url => @feed_info.url,
      :feed_url_s => @feed_info.feed_url,
      :etag => @feed_info.etag,
      :last_modified => @feed_info.last_modified)
  end
end

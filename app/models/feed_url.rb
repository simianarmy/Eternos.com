# $Id$

# BackupSource STI class child
require 'columbus'

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
        @feed_info = Feedzirra::Feed.fetch_and_parse(self.rss_url, :timeout => 30)
        unless valid_feed? @feed_info
          # Try feed auto-discovery
          @feed_info = Feedzirra::Feed.fetch_and_parse Columbus.new(self.rss_url).primary.url
        end
      rescue
      end
      if valid_feed? @feed_info
        self.auth_confirmed = true
      else
        errors.add(:rss_url, "Invalid RSS feed")
      end
    end
  end
  
  def save_feed
    create_feed(:title  => @feed_info.title.sanitize, 
      :url              => @feed_info.url,
      :feed_url_s       => @feed_info.feed_url,
      :etag             => @feed_info.etag,
      :last_modified    => @feed_info.last_modified)
  end
  
  def valid_feed?(feed)
    !(feed.nil? || feed.kind_of?(Fixnum) || feed.entries.blank?)
  end
end

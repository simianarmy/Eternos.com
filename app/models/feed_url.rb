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
  
  def num_items
    feed ? feed.entries.size : 0
  end
  
  def name
    feed.title
  end
  
  protected
  
  def validate_feed
    unless self.rss_url.blank?
      begin
        # feed:// should be converted to http://
        url = self.rss_url.gsub('feed://', 'http://')
        # prepend protocol to url if necessary
        unless self.rss_url =~ /^(https?|feed):\/\//
          self.rss_url = url = 'http://' + url
        end
        logger.debug "validating feed url #{url}"
        @feed_info = Feedzirra::Feed.fetch_and_parse(url, :timeout => 30)
        unless valid_feed? @feed_info
          # Try feed auto-discovery
          @feed_info = Feedzirra::Feed.fetch_and_parse Columbus.new(url).primary.url
        end
      rescue
      end
      errors.add(:rss_url, "Invalid RSS feed") unless valid_feed? @feed_info
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

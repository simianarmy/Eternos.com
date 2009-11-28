# $Id$

class FeedEntry < ActiveRecord::Base
  belongs_to :feed
  has_one :feed_content, :dependent => :destroy
  
  validates_uniqueness_of :guid, :scope => :feed_id
  
  include TimelineEvents
  serialize :categories
  serialize_with_options do
    methods :screencap_url, :screencap_thumb_url
  end
  
  xss_terminate :except => [ :categories ]
  acts_as_archivable :on => :published_at
  acts_as_taggable_on :tags
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  include CommonDateScopes
  after_create :save_contents
  
  def to_debug
    puts "Author: #{author}"
    puts "Title: #{name}"
    puts "URL: #{url}"
    puts "Published: #{published_at}"
    puts "Summary: #{summary}"
    puts "Contents: #{rss_content}"
  end
  
  def preview
    summary || rss_content
  end
  
  def bytes
    feed_content.try(:bytes) || 0
  end
  
  def screencap_url
    feed_content.try(:screencap_url)
  end
  
  def screencap_thumb_url
    feed_content.try(:screencap_thumb_url)
  end
  
  def member
    feed.feed_url.member
  end
  
  protected
  
  def save_contents
    create_feed_content if self.url
    true
  end
end

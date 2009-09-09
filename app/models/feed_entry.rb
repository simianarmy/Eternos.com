# $Id$

class FeedEntry < ActiveRecord::Base
  belongs_to :feed
  has_one :feed_content
  
  validates_uniqueness_of :guid, :scope => :feed_id
  
  serialize :categories
  xss_terminate :except => [ :categories ]
  acts_as_archivable :on => :published_at

  # TODO: Just use self.newest (see acts_as_archivable)
  named_scope :latest, :order => 'published_at DESC', :limit => 1
  named_scope :between_dates, lambda {|s, e| 
    { :conditions => ['DATE(published_at) BETWEEN ? AND ?', s, e] }
  }
  after_create :save_contents
  
  def to_s
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
    (summary ? summary.length : 0) + (rss_content ? rss_content.length : 0) + 
    (feed_content ? feed_content.content.size : 0)
  end
  
  def screencap_url
    feed_content.screencap.url rescue nil
  end
  
  def screencap_thumb_url
    feed_content.screencap.url(:thumb) rescue nil
  end
  
  protected
  
  def save_contents
    create_feed_content if self.url
    true
  end
end

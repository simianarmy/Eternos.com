# $Id$

class FeedEntry < ActiveRecord::Base
  belongs_to :feed
  validates_uniqueness_of :guid, :scope => :feed_id
  
  serialize :categories
  xss_terminate :except => [ :categories ]
  acts_as_archivable :on => :published_at

  # TODO: Just use self.newest (see acts_as_archivable)
  named_scope :latest, :order => 'published_at DESC', :limit => 1

  after_create :fetch_contents
  
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
    (summary ? summary.length : 0) + (rss_content ? rss_content.length : 0)
  end
  
  private
  
  # scrape full source from url
  def fetch_contents
    # Not now
    if false && url
      c = Curl::Easy.perform(url)
      update_attribute(:url_content, c.body_str)
    end
    true
  end
end

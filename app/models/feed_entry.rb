# $Id$

class FeedEntry < ActiveRecord::Base
  belongs_to :feed
  has_one :feed_content, :dependent => :destroy
  
  validates_presence_of :name
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
  
  named_scope :belonging_to_user, lambda {|member_id|
    { :joins => {:feed => :feed_url},
      :conditions => ['backup_sources.user_id = ?', member_id]
    }
  }
  # named_scope below fails on nil.call error
  # scope_procedure :belonging_to_user, lambda { |user_id| 
  #     feed_feed_url_user_id_eq(user_id)
  #   }
  named_scope :include_content, :include => :feed_content

  # thinking_sphinx
  define_index do
    indexes author
    indexes :name
    indexes summary
    indexes feed_content.html_content, :as => :raw_content
    indexes url
    indexes categories
    indexes tags(:name), :as => :tags
    indexes comments(:title), :as => 'comment_title'
    indexes comments(:comment), :as => :comment
    
    has feed_id, published_at, created_at, guid
    
    where 'deleted_at IS NULL'
  end
    
  include CommonDateScopes
  after_create :save_contents
  before_destroy :soft_delete
  
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
  
  def soft_delete
    self.update_attribute(:deleted_at, Time.now)
    false # prevent activerecord from deleting from table
  end
end

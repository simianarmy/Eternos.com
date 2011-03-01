# $Id$

# ActivityStreamItem STI base class

class ActivityStreamItem < ActiveRecord::Base
  belongs_to :activity_stream
  belongs_to :content
  has_one :member, :through => :activity_stream
  
  acts_as_archivable :on => :published_at, :order => 'DESC'
  acts_as_taggable_on :tags
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  include TimelineEvents
  include CommonDateScopes
  include BackupObjectComment
  
  named_scope :linkedin, :conditions => {:type => 'LinkedinActivityStreamItem'} 
  named_scope :facebook, :conditions => {:type => 'FacebookActivityStreamItem'}
  named_scope :twitter, :conditions => {:type => 'TwitterActivityStreamItem'}
  named_scope :with_attachment, :conditions => ['attachment_data IS NOT ?', nil]
  named_scope :with_photo, :conditions => {:attachment_type => 'photo'}
  named_scope :with_video, :conditions => {:attachment_type => 'video'}
  
  # serialization problems on OS X (works fine on RHEL5)
  serialize :attachment_data
  serialize :comment_thread
  serialize :liked_by
  
  # thinking_sphinx
  define_index do
    # fields
    indexes author
    indexes message
    indexes attachment_data, :as => :metadata
    indexes tags(:name), :as => :tags
    indexes comments(:title), :as => 'comment_title'
    indexes comments(:comment), :as => :comment
    
    # attributes
    has activity_stream_id, published_at, edited_at
    
    where "deleted_at IS NULL"
  end
  
  # Helpers for synching object from backup proxy object
  def sync_from_proxy!(p)
    # Uniqueness based on optional passed find query
    update_attributes!(
      :author         => p.author,
      :source_url     => p.source_url,
      :attribution    => p.attribution,
      #:comment_thread => p.comments,
      :liked_by       => p.likers)
    # Synch any comments
    synch_backup_comments(p.comments) if p.comments && p.comments.any?
  end
  
  def needs_sync?(p)
    #self.comment_thread != p.comments || 
    self.comments != p.comments ||
    self.liked_by != p.likers
  end
  
  def self.create_from_proxy!(activity_stream_id, proxy)
    create!({:activity_stream_id => activity_stream_id}.merge(proxy_to_attributes(proxy))) do |new_item|
      if proxy.comments && proxy.comments.any?
        new_item.synch_backup_comments(proxy.comments)
      end
    end
  end
  
  # Converts proxy object to hash containing table column to value pairs
  def self.proxy_to_attributes(item)
    {
    :guid             => item.id,
    :author           => item.author,
    :edited_at        => item.updated ? Time.at(item.updated) : nil,
    :published_at     => item.created ? Time.at(item.created) : nil,
    :message          => item.message,
    :source_url       => item.source_url,
    :attribution      => item.attribution,
    :activity_type    => item.activity_type,
    :attachment_data  => item.attachment_data,
    :attachment_type  => item.attachment_type,
    #:comment_thread   => item.comments,
    :liked_by         => item.likers
    }
  end

  # Helper class method to convert Comment object or comment_thread structure to 
  # a common data format
  def self.normalize_comment_data(obj)
    returning(Hashie::Mash.new) do |c|
      if obj.respond_to?(:commenter_data)
        c.username    = obj.commenter_data['username']
        c.user_pic     = obj.commenter_data['pic_url']
        c.profile_url = obj.commenter_data['profile_url']
        c.comment     = obj.comment
        c.posted_at   = obj.created_at
      elsif obj.respond_to?(:user_pic)
        c.username    = obj.username
        c.user_pic     = obj.user_pic
        c.profile_url = obj.profile_url
        c.comment     = obj.text
        c.posted_at   = Time.at(obj.time.to_i)
      end
    end
  end
  
  def bytes
    message.length + (attachment_data ? attachment_data.length : 0)
  end
  
  # Helpers to handle dual comments storage structure (comment_thread col. & comments has_many assoc.)
  def has_comments?
    comments.any? || comment_thread
  end
  
  def get_comments
    # Comments association has priority over serialized column data
    comments.any? ? comments : comment_thread
  end
  
  # Override these in child classes
  def url; end
  def thumbnail_url; end
  def media_attachment?; false end
  def parsed_attachment_data
    d = self.attachment_data
  end
end


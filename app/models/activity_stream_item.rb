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

  serialize :attachment_data
  
  include TimelineEvents
  
  include CommonDateScopes
  named_scope :facebook, :conditions => {:type => 'FacebookActivityStreamItem'}
  named_scope :twitter, :conditions => {:type => 'TwitterActivityStreamItem'}
  named_scope :with_attachment, :conditions => ['attachment_data IS NOT ?', nil]
  named_scope :with_photo, :conditions => {:attachment_type => 'photo'}
  named_scope :with_video, :conditions => {:attachment_type => 'video'}
  
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

  # Creates object from a ActivityStreamProxy instance
  def self.create_from_proxy(item)
    create!(
      :guid             => item.id,
      :author           => item.author,
      :edited_at        => item.updated ? Time.at(item.updated) : nil,
      :published_at     => item.created ? Time.at(item.created) : nil,
      :message          => item.message,
      :activity_type    => item.type,
      :attachment_data  => item.attachment_data,
      :attachment_type  => item.attachment_type)
  end
  
  def bytes
    message.length + (attachment_data ? attachment_data.length : 0)
  end
  
  # Override these in child classes
  def url; end
  def thumbnail_url; end
  def media_attachment?; false end
  def parsed_attachment_data
    self.attachment_data
  end
end


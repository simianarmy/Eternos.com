# $Id$

# ActivityStreamItem STI base class

class ActivityStreamItem < ActiveRecord::Base
  belongs_to :activity_stream
  belongs_to :content
  
  acts_as_archivable :on => :published_at, :order => 'DESC'
  
  serialize :attachment_data
  
  include TimelineEvents
  
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
  
  include CommonDateScopes
  named_scope :facebook, :conditions => {:type => 'FacebookActivityStreamItem'}
  named_scope :twitter, :conditions => {:type => 'TwitterActivityStreamItem'}
  named_scope :with_attachment, :conditions => ['attachment_data IS NOT ?', nil]
  named_scope :with_photo, :conditions => {:attachment_type => 'photo'}
  named_scope :with_video, :conditions => {:attachment_type => 'video'}
  
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


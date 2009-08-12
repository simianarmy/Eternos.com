# $Id$

# ActivityStreamItem STI base class

class ActivityStreamItem < ActiveRecord::Base
  belongs_to :activity_stream
  
  acts_as_archivable :on => :published_at
  
  # Creates object from a ActivityStreamProxy instance
  def self.create_from_proxy(item)
    create!(
      :guid             => item.id,
      :edited_at        => item.updated ? Time.at(item.updated) : nil,
      :published_at     => item.created ? Time.at(item.created) : nil,
      :message          => item.message,
      :activity_type    => item.type,
      :attachment_data  => item.attachment_data,
      :attachment_type  => item.attachment_type)
  end
  
  named_scope :facebook, :conditions => {:type => 'FacebookActivityStreamItem'}
  named_scope :twitter, :conditions => {:type => 'TwitterActivityStreamItem'}
  named_scope :with_attachment, :conditions => ['attachment_data IS NOT ?', nil]
  named_scope :with_photo, :conditions => {:attachment_type => 'photo'}
  named_scope :with_video, :conditions => {:attachment_type => 'video'}
  named_scope :latest, lambda { |num|
    {
      :order => 'published_at DESC', :limit => num || 1
    }
  }
  
  def bytes
    message.length + (attachment_data ? attachment_data.length : 0)
  end
  
  private
  
  def parsed_attachment_data
    @data ||= YAML::parse attachment_data
  end
end

# STI class children

class FacebookActivityStreamItem < ActivityStreamItem
  def url
    return unless d = parsed_attachment_data
    
    case attachment_type
    when 'photo'
      d['src'].value.gsub(/_s\./, '_n.')
    when 'video'
      d['video']['source_url'].value
    end
  end
  
  def thumbnail_url
    return unless d = parsed_attachment_data
    
    case attachment_type
    when 'photo'
      d['src'].value
    when 'video'
      d['video']['source_url'].value
    end
  end
end

class TwitterActivityStreamItem < ActivityStreamItem
  def url
  end
  
  def thumbnail_url
    # Get associated content thumbnail...if possible
  end
end

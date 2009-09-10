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
  named_scope :between_dates, lambda {|s, e| 
    { :conditions => ['DATE(published_at) BETWEEN ? AND ?', s, e] }
  }
  
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

# STI class children

class FacebookActivityStreamItem < ActivityStreamItem
  after_create :process_attachment
  
  serialize_with_options do
    methods :start_date, :url, :thumbnail_url
    except :guid, :attachment_data
  end
  
  def url
    return unless d = parsed_attachment_data
    
    case attachment_type
    when 'photo'
      d['src'].gsub(/_s\./, '_n.')
    when 'video'
      d['video']['source_url']
    when 'generic'
      parse_link d['href']
    when 'link'
      d['href']
    end
  end
  
  def thumbnail_url
    return unless d = parsed_attachment_data
    
    case attachment_type
    when 'photo'
      d['src']
    when 'video'
      d['video']['source_url']
    end
  end
    
  def media_attachment?
    attachment_data && ["photo", "video"].include?(attachment_type.downcase)
  end
  
  def parse_link(link)
    if link.match(/.+url=([^&]+).*$/)
      CGI::unescape $1
    else
      link
    end
  end
  
  def process_attachment
    return unless d = parsed_attachment_data
    
    case self.attachment_type
      # Parse generic attachment attributes into string for the message attribute
    when 'generic'
      message = ''
      message += "Name: #{d['name']}\n" if d['name']
      message += "Caption: #{d['caption']}\n" if d['caption']
      message += "Description: #{d['description']}\n" if d['description']

      self.update_attribute(:message, message) unless message.blank?
    end
    true
  end
end

class TwitterActivityStreamItem < ActivityStreamItem
  serialize_with_options do
    methods :start_date
    except :guid, :attachment_data
  end
end

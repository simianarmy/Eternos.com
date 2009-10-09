# $Id$

# ActivityStreamItem STI class child

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
      # Either facebook photo or uses src attribute
      if facebook_photo?
        # Don't return anything if associated photo object not found
        facebook_photo.try(:url)
      else
        d['src'].gsub(/_s\./, '_n.')
      end
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
      # Either facebook photo or uses src attribute
      if facebook_photo?
        # Don't return anything if associated photo object not found
        facebook_photo.try(:thumbnail_url)
      else
        d['src']
      end
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
  
  def facebook_photo?
    (d = parsed_attachment_data['photo']) && !d['pid'].empty?
  end
  
  def facebook_photo
    if pid = parsed_attachment_data['photo']['pid']
      @fb_photo ||= BackupPhoto.find_by_source_photo_id(pid).photo rescue nil
    end
  end
  
  def process_attachment
    return unless d = parsed_attachment_data
    
    case self.attachment_type
      # Parse generic attachment attributes into string for the message attribute
    when 'generic'
      message = ''
      message += "Name: #{d['name']}\n" unless d['name'].blank?
      message += "Caption: #{d['caption']}\n" unless d['caption'].blank?
      message += "Description: #{d['description']}\n" unless d['description'].blank?

      self.update_attribute(:message, message) unless message.blank?
    end
    true
  end
    
end

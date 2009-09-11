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

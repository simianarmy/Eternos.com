# $Id$

# ActivityStreamItem STI class child

class FacebookActivityStreamItem < ActivityStreamItem
  include AfterCommit::ActiveRecord
  
  after_commit_on_create :process_attachment_message
  # Must be on_update, not on_create because we need to be able to fetch the 
  # item's member attribute, which is sometimes not set until after the object
  # is committed.
  # Ex:
  # @activity_stream.items << FacebookActivityStreamItem.create(...)
  after_commit_on_update :process_attachment_photo
  
  serialize_with_options do
    methods :url, :thumbnail_url
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
  
  # Returns Photo object created from attached BackupPhoto object
  def facebook_photo
    @fb_photo ||= backup_photo.photo rescue nil
  end
  
  # Returns attached BackupPhoto object
  def backup_photo
    if pid = parsed_attachment_data['photo']['pid']
      BackupPhoto.find_by_source_photo_id(pid) rescue nil
    end
  end
  
  protected

  def process_attachment_message
    return unless d = parsed_attachment_data
    
    case self.attachment_type
    when 'generic'
      # Parse generic attachment attributes into string for the message attribute
      message = ''
      message << "#{d['name']}\n" unless d['name'].blank?
      message << "#{d['caption']}\n" unless d['caption'].blank?
      message << "#{d['description']}\n" unless d['description'].blank?

      self.update_attribute(:message, message) unless message.blank?
    end
    true
  end
  
  def process_attachment_photo
    return unless d = parsed_attachment_data
    
    case self.attachment_type
    when 'photo'
      # Add photo to be downloaded if it is a photo from a facebook album.
      # requires the backup_source object, which means this object must be created AND
      # associated with its activity_stream (from which we derive the member attribute, 
      # then the facebook backup source object, phew!)
      if facebook_photo? && !backup_photo && member
        # add to album (create one if necessary)
        # need to retrieve our facebook backup source object for album creation
        begin
          bs = member.backup_sources.facebook.first
          album = BackupPhotoAlbum.find_or_create_by_backup_source_id_and_source_album_id(bs.id, d['photo']['aid'])

          BackupPhoto.create(:backup_photo_album => album,
            :source_photo_id => d['photo']['pid'],
            :source_url => d['src'],
            :caption => self.message)
        rescue
          logger.error "FacebookActivityStreamItem::process_attachment exception: " + $!
          raise
        end
      end
    end
    true
  end
  
end

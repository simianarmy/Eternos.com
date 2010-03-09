# $Id$

# ActivityStreamItem STI class child

class FacebookActivityStreamItem < ActivityStreamItem
  after_create :process_attachment 
  
  serialize_with_options do
    methods :url, :thumbnail_url, :parsed_attachment_data
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
    attachment_type && attachment_data &&  ["photo", "video"].include?(attachment_type.downcase)
  end
  
  def parse_link(link)
    if link && link.match(/.+url=([^&]+).*$/)
      CGI::unescape $1
    else
      link
    end
  end
  
  def facebook_photo?
    (d = parsed_attachment_data['photo']) && d['pid'] && !d['pid'].empty?
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

  # Do additional parsing of facebook attachment data structure in order 
  # to extract additional information & download required media
  def process_attachment
    return true unless d = parsed_attachment_data

    case self.attachment_type
    when 'link', 'generic'
      # Parse generic attachment attributes into string for the message attribute
      if self.message.blank?
        mesg = ''
        mesg << "#{d['name']}\n" unless d['name'].blank?
        mesg << "#{d['caption']}\n" unless d['caption'].blank?
        mesg << "#{d['description']}\n" unless d['description'].blank?
        self.update_attribute(:message, mesg) unless mesg.blank?
      end
    when 'photo'
      # Add photo to be downloaded if it is a photo from a facebook album.
      # requires the backup_source object, which means this object must be created AND
      # associated with its activity_stream (from which we derive the member attribute, 
      # then the facebook backup source object, phew!)
      if facebook_photo? && !backup_photo && member
        # add to album (create one if necessary)
        # need to retrieve our facebook backup source object for album creation
        begin
          # If photo doesn't belong to this user, use a catch-all photo album 
          # to store them
          bs = member.backup_sources.facebook.first
          album = if d['photo']['owner'] != member.facebook_id.to_s
            # This sucks...why doesn't find_or_create work with extra attributes?
            BackupPhotoAlbum.find_or_create_facebook_friends_album(bs.id)
          else
            BackupPhotoAlbum.find_or_create_by_backup_source_id_and_source_album_id(bs.id, d['photo']['aid'])
          end

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

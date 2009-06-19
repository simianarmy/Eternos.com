# $Id$


# Should be used as model for other site classes (ie. Flickr)

require 'backup_content_proxies'
require 'facebooker'

class FacebookPhotoAlbum < BackupPhotoAlbumProxy
  attr_reader :album
  
  def initialize(a)
    raise InvalidAlbumClassError unless a.class == Facebooker::Album
    @album = a
  end
  
  def id
    @album.aid
  end
  
  def cover_id
    @album.cover_pid
  end
end

class FacebookPhoto < BackupPhotoProxy
  attr_reader :photo
  attr_accessor :tags
  
  def initialize(p)
    raise InvalidPhotoClassError unless p.class == Facebooker::Photo
    @photo = p
  end
  
  def id
    @photo.pid
  end
  
  def source_url
    @photo.src_big
  end
end
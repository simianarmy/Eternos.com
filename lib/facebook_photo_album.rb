# $Id$


# Should be used as model for other site classes (ie. Flickr)

require 'lib/backup_content_proxy'
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
  attr_accessor :tags, :comments
  alias_attribute :id, :pid
  alias_attribute :source_url, :src_big
  
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
  
  def added_at
    Time.at(@photo.created.to_i) unless @photo.created.blank?
  end
  
  def modified_at
    nil # not supported by facebook
  end
end
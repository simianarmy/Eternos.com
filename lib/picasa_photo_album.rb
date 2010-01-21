# $Id$

require 'lib/backup_content_proxy'

class PicasaPhotoAlbum < BackupPhotoAlbumProxy
  attr_reader :album
  
  # alias picasa-specific attribute names to standardize attribute
  alias_attribute :id, :album_id
  alias_attribute :name, :title
  alias_attribute :description, :summary
  alias_attribute :size, :num_photos
  
  def initialize(a)
    @album = a
  end
  
  # Convert datetime string to timestamp
  def modified
    Time.parse(@album.updated).utc.to_i unless @album.updated.blank?
  end
  
  def published_at
    @album.published.to_datetime.utc
  end
end

class PicasaPhoto < BackupPhotoProxy
  attr_reader :photo
  
  # alias picasa-specific attribute names to standardize attribute  
  alias_attribute :id, :photo_id
  alias_attribute :caption, :summary
  alias_attribute :source_url, :photo_url_s
  
  def initialize(p)
    @photo = p
  end
  
  def added_at
    @photo.published.to_datetime.utc
  end
  
  # Convert datetime string to timestamp
  def modified_at
    @photo.updated.to_datetime.utc
  end
end
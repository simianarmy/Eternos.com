# $Id$

# Proxy classes to normalize backup source classes used to store backup data.
# Child classes used by ActiveRecord classes to create/update info in a consistent way

# See facebook_photo_album.rb for usage example

module BackupContentProxy
  def to_h
    db_attributes.inject({}) { |h, attr| h[attr] = send(attr); h }
  end
  
  def method_missing(sym, *args, &block)
    obj.send sym, *args, &block
  end
  
  def obj
    raise "Implement me!"
  end
end

class BackupPhotoAlbumProxy
  include BackupContentProxy
  class InvalidAlbumClassError < StandardError; end
  
  def db_attributes
    BackupPhotoAlbum.db_attributes
  end
  
  def obj
    @album
  end
end

class BackupPhotoProxy
  include BackupContentProxy
  class InvalidPhotoClassError < StandardError; end
  
  def db_attributes
    BackupPhoto.db_attributes
  end
  
  def obj
    @photo
  end
end

class BackupObjectCommentProxy
  include BackupContentProxy
  class InvalidCommentClassError < StandardError; end
  
  def db_attributes
    Comment.db_attributes
  end
  
  def obj
    @comment
  end
end


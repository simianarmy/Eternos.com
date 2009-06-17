# $Id$

# Helper class to normalize facebook photo album attributes
# NOTE:
# Should be used as model for other site photo album classes (ie. Flickr)
# and later moved into a module with hierarchies.

require 'facebooker'

class FacebookPhotoAlbum
  class InvalidAlbumClassError < StandardError; end
    
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
  
  def method_missing(sym, *args, &block)
    @album.send sym, *args, &block
  end
end
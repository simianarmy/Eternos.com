# $Id$
#
# Mixin for user content collections

module ContentCollections
  
  # Mixin for photo album collections
  module PhotoAlbum
    # Returns all albums (collections) owned by a user
    def photo_albums
      self.contents.photos.collections.map(&:collection).compact.uniq.reject do |al| 
        # ENSURE THAT ALBUM BELONGS TO US!
        (al.owner != self) || 
        # EXTRA CHECKS FOR EMPTY OR UNTITLED ALBUMS NECESSARY??
        (al.size == 0) || al.name.nil?
      end
    end
  end
end

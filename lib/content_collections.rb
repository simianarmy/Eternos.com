# $Id$
#
# Mixin for user content collections

module ContentCollections
  
  # Mixin for photo album collections
  module PhotoAlbum
    # Returns all albums (collections) owned by a user
    def photo_albums
      self.contents.photos.collections.map(&:collection).compact.uniq.reject do |al| 
          (al.owner != self) || (al.num_items == 0) || al.name.nil?
      end
    end
  end
end
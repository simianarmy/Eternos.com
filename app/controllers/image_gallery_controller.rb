# $Id$

class ImageGalleryController < ApplicationController
  before_filter :login_required
  require_role "Member"
  layout false

  def show
    @title = current_user.first_name + "'s Image Gallery"
    # Format photos collection into JSON data for gallery builder JS
    # Group by photo album
    
    s = BackupPhotoAlbum.by_user(current_user.id).include_content_photos.searchlogic
    s.id_eq(params[:album_id]) if params[:album_id]
    #Album.by_user(current_user.id).id_eq(@album_id).include_photos
    
    # work-around for goddamn json bug (yes here it is again I f'ing hate it)
    # @albums = current_user.contents.photos.collections.compact.uniq.to_json(:gallery)
    # ERROR:
    # TypeError: wrong argument type Symbol (expected Data)
    # workaround: hack array symbols around json hash list
    
    # Find all albums, to_json(:gallery) call will load the contents (Photo objects)
    #@albums = current_user.contents.photo_albums.map(&:collection).
      # Don't know how to sort by polymorhphic association column in named_scope,
      # so sort by album date (descending) manually
    @albums = s.all.
      reject {|al| (al.num_items == 0) || al.name.nil?}.
      compact.sort {|a,b| b.created_at <=> a.created_at}.
      # Convert each album to json in gallery format
      map do |al|
        begin
          al.to_json(:gallery) 
        rescue Exception => e
          RAILS_DEFAULT_LOGGER.error "Exception in to_json(:gallery) for album #{al.id}: #{e.to_s}"
          # return empty hash?
          {}
        end
      end.join(',')
    @albums.gsub!('"{', '{')
    @albums.gsub!('}"', '}')
    @albums.gsub!('content_photos', 'photos')
    @albums = "[#{@albums}]"
    
    respond_to do |format|
      format.html
    end
  end
end
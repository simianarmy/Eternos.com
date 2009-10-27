# $Id$

class ImageGalleryController < ApplicationController
  before_filter :login_required
  require_role "Member"
  layout false

  def show
    @title = current_user.first_name + "'s Image Gallery"
    # Format photos collection into JSON data for gallery builder JS
    # Group by photo album
    
    # work-around for goddamn json bug (yes here it is again I f'ing hate it)
    # @albums = current_user.contents.photos.collections.compact.uniq.to_json(:gallery)
    # ERROR:
    # TypeError: wrong argument type Symbol (expected Data)
    # workaround: hack array symbols around json hash list
    @albums = current_user.contents.photos.collections.map(&:collection).
      # Don't know how to sort by polymorhphic association column in named_scope,
      # so sort by album date (descending) manually
      compact.sort {|a,b| b.created_at <=> a.created_at}.
      # Convert each album to json in gallery format
      map{|al| al.to_json(:gallery)}.join(',')
    @albums.gsub!('"{', '{')
    @albums.gsub!('}"', '}')
    @albums.gsub!('backup_photos', 'photos')
    @albums = "[#{@albums}]"
    
    respond_to do |format|
      format.html
    end
  end
end
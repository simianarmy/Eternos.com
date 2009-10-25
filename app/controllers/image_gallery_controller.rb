# $Id$

class ImageGalleryController < ApplicationController
  before_filter :login_required
  require_role "Member"
  layout nil

  def show
    @title = current_user.first_name + "'s Image Gallery"
    # Format photos collection into JSON data for gallery builder JS
    
    # work-around for goddamn json bug (yes here it is again I f'ing hate it)
    # @albums = current_user.contents.photos.collect {|p| p.collection}.compact.uniq.to_json(:gallery)
    # ERROR:
    # TypeError: wrong argument type Symbol (expected Data)
    # workaround: hack array symbols around json hash list
    @albums = current_user.contents.photos.collect {|p| p.collection}.compact.uniq.
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
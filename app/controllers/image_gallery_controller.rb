# $Id$

class ImageGalleryController < MemberHomeController
  layout nil
  skip_before_filter :load_member_home_presenter
  
  def show
    @title = current_user.first_name + "'s Image Gallery"
    
    respond_to do |format|
      format.html
    end
  end
  
  def albums
    # Find all albums, to_json(:gallery) call will load the contents (Photo objects)
    # Don't know how to sort by polymorhphic association column in named_scope,
    # so sort by album date (descending) manually
      
    albums = Rails.cache.fetch("albums:#{current_user.id}") { 
      current_user.contents.photos.collections.map(&:collection).compact.uniq.reject { |al| 
          (al.owner != current_user) || (al.num_items == 0) || al.name.nil?
        }.sort {|a,b| b.start_date <=> a.start_date}
        
      # work-around for goddamn json bug (yes here it is again I f'ing hate it)
      # @albums = current_user.contents.photos.collections.compact.uniq.to_json(:gallery)
      # ERROR:
      # TypeError: wrong argument type Symbol (expected Data)
      # workaround: hack array symbols around json hash list
      
      # Get backup photo albums 1st
      # s = BackupPhotoAlbum.by_user(current_user.id).include_content_photos.searchlogic
      #       s.id_eq(params[:album_id].split(',')) if params[:album_id]
      #       
      #       coll = s.all.reject {|al| (al.owner != current_user) || (al.num_items == 0) || al.name.nil?}.
      #         compact.sort {|a,b| b.start_date <=> a.start_date}
      #         # Convert each album to json in gallery format
      #         map do |al|
      #           begin
      #             # This is weird but directly calling to_json on the record raises NoMethodError exception
      #             # from active record serialization module.
      #             # Workaround is to reload the object
      #             al.reload.to_json(:gallery) 
      #           rescue Exception => e
      #             RAILS_DEFAULT_LOGGER.error "Exception in to_json(:gallery) for album #{al.id}: #{e.to_s}"
      #             # return empty hash?
      #             {}
      #           end
      #         end
    }
    # Weird json conversion required b/c calling to_json(:gallery) on an array doesn't work
    
    albums_str = albums.map{|a| a.to_json(:gallery)}.join(',')
    albums_str.gsub!('"{', '{')
    albums_str.gsub!('}"', '}')
    albums_str.gsub!('content_photos', 'photos')
    @albums = "[#{albums_str}]"
    
    respond_to do |format|
      format.js { render :inline => @albums }
    end
  end
end
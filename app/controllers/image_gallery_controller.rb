# $Id$

class ImageGalleryController < MemberHomeController
  layout nil
  skip_before_filter :load_member_home_presenter
  
  ssl_allowed :show, :albums
  
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
      
    albums = Rails.cache.fetch("albums:#{current_user.id}", :force => force_cache_reload?(:images), :expires => 1.hour) { 
      current_user.photo_albums.sort {|a,b| b.start_date <=> a.start_date}
      #s.id_eq(params[:album_id].split(',')) if params[:album_id]
    }
    use_cache!(:images)
    
    Rails.logger.debug "Albums: #{albums.map(&:name)}" if albums
    # Weird json conversion required b/c calling to_json(:gallery) on an array doesn't work
    albums_str = albums.map{|a| a.to_json(:gallery)}.join(',')
    albums_str.gsub!('"{', '{')
    albums_str.gsub!('}"', '}')
    albums_str.gsub!('content_photos', 'photos') # For backup photo albums
    @albums = "[#{albums_str}]"
    
    respond_to do |format|
      format.js { render :inline => @albums }
    end
  end
end
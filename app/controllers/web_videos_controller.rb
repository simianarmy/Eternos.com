# $Id$

class WebVideosController < VideosController
  resource_controller
  
  def show
    respond_to do |format|
      format.flv { send_protected_content(object.full_filename, 'video/x-flv') }
      format.html
    end
  end
  
  private
  def collection
    @collection = current_user.contents.find_all_by_type('WebVideo')
  end
    
  # Sets both @content and @photo to instance 
  def load_object
    instance_variable_set '@content', object
    super
  end
end
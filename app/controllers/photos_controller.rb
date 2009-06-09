# $Id$
class PhotosController < ContentsController
  resource_controller
  before_filter :login_required
  belongs_to :owner
  
  private
  def collection
    @collection = current_user.contents.find_all_by_type('Photo')
  end
    
  # Sets both @content and @photo to instance 
  def load_object
    instance_variable_set '@content', object
    super
  end
end

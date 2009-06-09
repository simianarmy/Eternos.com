# $Id$
class VideosController < ContentsController
  resource_controller
  before_filter :login_required
  belongs_to :owner
  
  private
  def collection
    @collection = current_user.contents.find_all_by_type('Video')
  end
    
  # Sets both @content and @video to instance 
  def load_object
    instance_variable_set '@content', object
    super
  end
end

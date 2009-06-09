# $Id$
class MusicController < AudioController
  resource_controller
  
  # From ResourceController::Helpers
  # Sets both @content and @audio to instance 
  def load_object
    instance_variable_set '@content', object
    super
  end
  
  private
  
end

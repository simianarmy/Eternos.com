# $Id$

class AudioController < ContentsController
  resource_controller
  
  index.wants.xml { render :xml => object }
  index.wants.pls { render :layout => false }
  
  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => object }
      format.mp3 { 
        send_protected_content(object.full_filename, 'audio/mp3')
        # rendering nothing FAILS too, wow the docs are so wrong on this
        #render :nothing => true
      }
      format.m3u { render :text => object.absolute_url(request) }
    end
  end
  
  update do
    flash "Successfully updated audio!"
    
    wants.html { redirect_to content_path(object) }
    wants.js { 
      render :template => 'contents/update' }
    
    failure.wants.js { 
      flash object.errors.full_messages
      object.reload
      render :template => 'contents/update'
    }
  end
  
  private
  def collection
    @collection ||= current_user.contents.find_all_by_type(['Audio', 'Music'])
  end
    
  def object
    @object ||= current_user.contents.find_by_id_and_type(params[:id], ['Audio', 'Music'])
  end
  
  # From ResourceController::Helpers
  # Sets both @content and @audio to instance 
  def load_object
    instance_variable_set '@content', object
    super
  end
  
end
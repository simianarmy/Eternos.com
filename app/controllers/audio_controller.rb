# $Id$

class AudioController < TimelineEventsController
  
  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @item }
      format.mp3 { 
        redirect_to @item.url(:private=>true)
      }
      format.m3u { render :text => item.absolute_url(request) }
    end
  end
  
  protected
  
  # Override to include Music types
  def load_item
    @object = @item = Content.find_by_id_and_type(params[:id], ['Audio', 'Music'])
    instance_variable_set "@#{@item.to_str}", @item
    raise ActionController::MethodNotAllowed unless @item.member == current_user
  end
  
end
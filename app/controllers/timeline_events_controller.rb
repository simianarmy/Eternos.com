# $Id$

class TimelineEventsController < ApplicationController
  before_filter :login_required
  require_role ['Guest', 'Member']

  # Better to use authorization plugin dsl
  before_filter :member_or_guests_only, :only => [:index]
  # For authorization dsl 
  before_filter :load_item, :only => [:show, :edit, :update, :destroy]
  layout 'dialog'
  
  def index
    type = params[:type]
    ids = params[:events]
    
    begin
      # TODO: Create class to restrict results to user = id
      @events ||= type.camelize.constantize.find(ids.split(',')).reject {|ev| ev.get_owner != current_user}
    rescue
      flash[:error] = "An unexpected error occurred while retrieving your details: " + $!
      @events = []
    end
  end
  
  def update
    respond_to do |format|
      object_name = @item.to_str
      if @item.update_attributes(params[object_name])
        flash[:notice] = "Successfully updated item."
        format.html {
          redirect_to @item
        }
        format.js {
          render :template => "timeline_events/update"
        }
      else
        format.html {
          render :action => 'edit'
        }
        format.js {
          render :template => "timeline_events/update"
        }
      end
    end
  end
  
  def destroy
    # Don't destroy AR object - just mark as deleted so that backup daemons don't
    # re-save
    @item.touch(:deleted_at)
    
    respond_to do |format|
      format.html {
        flash[:notice] = "Successfully destroyed item!"
      }
      format.js {
        render :nothing => true, :status => 200
      }
    end
  end
  
  protected
  
  def load_item
    obj = params[:controller].classify.constantize
    @item = obj.find(params[:id])
    instance_variable_set "@#{@item.to_str}", @item
    raise ActionController::MethodNotAllowed unless @item.member == current_user
  end
  
  def member_or_guests_only
    # TODO: Need check for guests here too (preferrably using permit syntax)
    unless current_user.id == params[:id].to_i
      flash[:error] = "Unauthorized Access"
      render :action => :index
      false
    end
  end
end

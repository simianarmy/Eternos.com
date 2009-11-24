# $Id$

class TimelineEventsController < ApplicationController
  before_filter :login_required
  require_role ['Guest', 'Member']
  #layout 'timeline_details'
  before_filter :member_or_guests_only
  
  def index
    type = params[:type]
    ids = params[:events]
    
    begin
      # TODO: Create class to restrict results to user = id
      @events ||= type.camelize.constantize.find(ids.split(','))
    rescue
      flash[:error] = "An unexpected error occurred while retrieving your details: " + $!
      @events = []
    end
  end
  
  private
  
  def member_or_guests_only
    # TODO: Need check for guests here too (preferrably using permit syntax)
    unless current_user.id == params[:id].to_i
      flash[:error] = "Unauthorized Access"
      render :action => :index
      false
    end
  end
end

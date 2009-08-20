# $Id$

class TimelineEventsController < ApplicationController
  before_filter :login_required
  require_role ['Guest', 'Member']
  layout 'dialog'
  
  def index
    type = params[:type]
    date = params[:date]
    
    begin
      # TODO: logged in user must be == user_id or guest of member w/ user_id
      @events = TimelineSearch.new(params[:id], [date, date]).by_type(type)
    end
    @events ||= []
  end
end

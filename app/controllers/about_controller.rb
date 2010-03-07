class AboutController < ApplicationController
  before_filter :hide_feedback_tab
  layout 'public'
  
  def index
    
  end
  
  def show
    render :action => params[:page]
  end

end

class AboutController < ApplicationController
  before_filter :hide_feedback_tab
  
  def index
    
  end
  
  def show
    render :action => params[:page]
  end

end

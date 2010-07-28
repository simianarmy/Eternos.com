class AboutController < ApplicationController
  before_filter :hide_feedback_tab
  layout 'public'
  
  def index
  end
  
  def company
    render :action => 'index'
  end
  
  def show
    render :action => 'index'
  end

end

# $Id$
class HomeController < ApplicationController
  ssl_allowed :index
  before_filter :set_facebook_connect_session
  before_filter :redirect_if_logged_in, :only => :index
  layout 'public'
  
  def new
    @user = User.new
  end
  
  def index
    @hide_feedback = true
  end
  
  def show
    @hide_feedback = true
    render :action => params[:page]
  end
  
  
  private
      
  def redirect_if_logged_in
    # Redirect to dashboard for logged in sessions unless user is coming 
    # from site link
    if current_user && (!request.referer || !request.referer.match(AppConfig.base_domain))
      redirect_to member_home_path
    end
  end
end

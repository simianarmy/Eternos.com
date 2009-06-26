# $Id$
class HomeController < ApplicationController
  layout 'public'
  ssl_allowed :index
  before_filter :load_facebook_connect
  before_filter :set_facebook_session 
  before_filter :redirect_if_logged_in, :only => :index
  
  def new
    @user = User.new
  end
  
  def index
  end
  
  def show
    render :action => params[:page]
  end
  
  private
  
  def redirect_if_logged_in
    # Redirect to dashboard for logged in sessions unless user is coming 
    # from site link
    redirect_to member_home_path if current_user && (!request.referer || !request.referer.match(AppConfig.base_domain))
  end
end

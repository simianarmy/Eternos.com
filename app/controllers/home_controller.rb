# $Id$
class HomeController < ApplicationController
  ssl_allowed :index
  before_filter :load_facebook_connect
  before_filter :set_facebook_session 
  before_filter :redirect_if_logged_in, :only => :index
  layout :dynamic_layout
  
  def new
    @user = User.new
  end
  
  def index
  end
  
  def show
    render :action => params[:page]
  end
  
  def test_lightview
    # WHY DOES :layout => 'empty' NOT WORK??? GAHHH!
    render :layout => 'empty' #, :layout => 'empty'
  end
  
  private
  
  def dynamic_layout
    super unless params[:page] == 'test_lightview_og'
  end
    
  def redirect_if_logged_in
    # Redirect to dashboard for logged in sessions unless user is coming 
    # from site link
    redirect_to member_home_path if current_user && (!request.referer || !request.referer.match(AppConfig.base_domain))
  end
end

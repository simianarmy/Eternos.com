# $Id$
class Vault::HomeController < ApplicationController
  #before_filter :redirect_if_logged_in, :only => :index
  layout 'vault/public'
  
  def new
    @user = User.new
  end
  
  def index
  end
  
  def show
    @hide_feedback = true
    render :action => params[:page]
  end
  
  def why
  end
  
  def services
  end
  
  def getting_started
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

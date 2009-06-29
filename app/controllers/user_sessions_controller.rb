# $Id$

# Authlogic sessions controller

class UserSessionsController < ApplicationController
  ssl_required :new, :index
  ssl_allowed :create, :destroy
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  before_filter :load_facebook_connect
  before_filter :set_facebook_session
  
  def new
    @user_session    = UserSession.new
  end

  # Here to catch weird redirect to index bug
  def index
    render :action => :new
  end
  
  def create
    @user_session    = UserSession.new(params[:user_session])
    
    if @user_session.save
      flash_redirect("Welcome, #{@user_session.user.name}", session[:original_uri] || member_home_url)
    else
      if facebook_session && !params['commit']
        redirect_to new_account_path
      else
        flash[:error] = I18n.t('user_sessions.new.login_failed')
        render :action => :new
      end
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end
end

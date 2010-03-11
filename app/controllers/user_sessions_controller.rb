# $Id$

# Authlogic sessions controller

class UserSessionsController < ApplicationController
  ssl_required :new, :index
  ssl_allowed :create, :destroy
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  before_filter :set_facebook_connect_session
  
  def new
    @user_session    = UserSession.new
  end

  # Here to catch weird redirect to index bug
  def index
    #@user_session    = UserSession.new
    #render :action => :new
    redirect_to member_home_path
  end
  
  def create
    @user_session    = UserSession.new(params[:user_session])
    
    if @user_session.save
      # 1st time logged in - send to account setup with welcome message
      if @user_session.user && (@user_session.user.login_count <= 1)
        flash[:notice] = "Welcome, #{@user_session.user.name}"
        redirect_to account_setup_url
      else # otherwise redirect back to last url, or member home
        redirect_back member_home_url
      end
    else
      if facebook_session && !params['commit']
        redirect_to new_account_path(:plan => 'Free')
      else
        flash[:error] = I18n.t('user_sessions.new.login_failed')
        render :action => :new
      end
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to new_user_session_url
  end
end

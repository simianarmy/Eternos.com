# $Id$

# Authlogic sessions controller

class Vault::UserSessionsController < ApplicationController
  ssl_required :new
  ssl_allowed :create, :destroy
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  layout 'vault/public/home'
  
  def new
    @user_session    = UserSession.new
  end

  # User gets routed here sometimes from improper request methods
  def index
    # Handle bookmarked or otherwise incorrect GETs to the login action
    if request.method == :get
      redirect_to login_path
    else
      redirect_to member_home_path
    end
  end

  def show
    redirect_to login_path
  end
  
  def create
    # Handle bookmarked or otherwise incorrect GETs to the login action
    if request.method == :get
      redirect_to(login_path) && return
    end

    sanitize_credentials
    UserSession.with_scope(:find_options => {:conditions => "accounts.site_id = 1", :include => :account}) do
      @user_session = UserSession.new(params[:user_session])
    end
    
    if @user_session.save
      # 1st time logged in - send to account setup with welcome message
      if @user_session.user && (@user_session.user.login_count <= 1)
        Rails.logger.debug "User logged in, redirecting to account setup"
        flash[:notice] = "Welcome, #{@user_session.user.name}"
        redirect_to account_setup_url
      else # otherwise redirect back to last url, or member home
        flash[:notice] = "Welcome back, #{@user_session.user.name}"
        redirect_back member_home_url
        #redirect_to member_home_path
      end
    else
      Rails.logger.error "Login failed! #{params.inspect}"

      flash[:error] = I18n.t('user_sessions.new.login_failed')
      render :action => :new
    end
  end

  def destroy
    current_user_session.try(:destroy)
    redirect_to vlogin_path
  end

  protected
  
  #  Strip whitespace from credentials - login failures can be caused by this from 
  # co-reg emails with passwords in them that contain invisible newlines or something!
  def sanitize_credentials
    if params[:user_session]
      params[:user_session][:login].strip!
      params[:user_session][:password].strip!
    end
  end
end

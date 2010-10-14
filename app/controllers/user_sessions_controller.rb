# $Id$

# Authlogic sessions controller

class UserSessionsController < ApplicationController
  ssl_required :new
  ssl_allowed :create, :destroy
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  
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
    @user_session    = UserSession.new(params[:user_session])
    
    if @user_session.save
      # 1st time logged in - send to account setup with welcome message
      if @user_session.user && (@user_session.user.login_count <= 1)
        Rails.logger.debug "User logged in, redirecting to account setup"
        flash[:notice] = "Welcome, #{@user_session.user.name}"
        redirect_to account_setup_url
      else # otherwise redirect back to last url, or member home
        redirect_back member_home_url
        #redirect_to member_home_path
      end
    else
      set_facebook_connect_session
      if facebook_session 
        if user = User.find_by_fb_user(facebook_session.user)
          # Make sure facebook session user == any login params
          if !@user_session.login.blank? && (user.login != @user_session.login)
            flash[:error] = I18n.t('user_sessions.new.login_failed')
            render(:action => :new) && return 
          end
          # Otherwise auto-login with user matching facebook session
          UserSession.create(user)
          if user.has_backup_data?
            redirect_to member_home_url
          else
            redirect_to account_setup_url
          end
          return false
        elsif !params['commit']
          redirect_to new_account_path(:plan => 'Free') and return false
        end
      end

      flash[:error] = I18n.t('user_sessions.new.login_failed')
      render :action => :new
    end
  end

  def destroy
    current_user_session.try(:destroy)
    redirect_to new_user_session_url
  end
end

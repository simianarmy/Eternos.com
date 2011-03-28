# $Id$

# Authlogic sessions controller

class UserSessionsController < ApplicationController
  ssl_required :new, :choose_password, :save_password
  ssl_allowed :create, :destroy
  
  before_filter :require_no_user, :only => [:new, :create, :choose_password, :save_password]
  before_filter :require_user, :only => :destroy
  
  layout 'home'
  
  def new
    if current_subdomain == 'vault'
      redirect_to vlogin_path and return false
    end
    session_scoped_by_site do
      @user_session    = UserSession.new
    end
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
    session_scoped_by_site do
      @user_session    = UserSession.new(params[:user_session])
    end
    
    if @user_session.save
      # REDIRECT EVERYONE TO PAY PAGE UNLESS ALREADY PAID
      begin
        unless @user_session.user.account.subscription.billing_id
          redirect_to(upgrade_loyalty_subscriptions_path) and return false
        end
      rescue
      end
      # 1st time logged in - send to account setup with welcome message
      if @user_session.user && (@user_session.user.login_count <= 1)
        Rails.logger.debug "User logged in, redirecting to account setup"
        # Redirect everyone to pay up page
        flash[:notice] = "Welcome, #{@user_session.user.name}"
        redirect_to account_setup_url
      else # otherwise redirect back to last url, or member home
        redirect_back member_home_url
        #redirect_to member_home_path
      end
    else
      Rails.logger.error "Login failed! #{params.inspect}"
      set_facebook_connect_session
      if facebook_session 
        if user = User.find_by_fb_user(facebook_session.user)
          # Make sure facebook session user == any login params
          if !@user_session.login.blank? && (user.login != @user_session.login)
            flash[:error] = I18n.t('user_sessions.new.login_failed')
            render(:action => :new) && return 
          end
          # Otherwise auto-login with user matching facebook session
          session_scoped_by_site { UserSession.create(user) }
          begin
            unless user.account.subscription.billing_id
              redirect_to(upgrade_loyalty_subscriptions_path) and return false
            end
          rescue
          end
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
    session_scoped_by_site { current_user_session.try(:destroy) }
    redirect_to new_user_session_url
  end
  
  # Should only be called from co-reg email links
  def choose_password
    session_scoped_by_site do
      @user_session = UserSession.new
    end
  end
  
  # Called from choose password form
  def save_password
    sanitize_credentials
    
    # If user login matches record and passwords match, save password to user account and log them in
    if (@user = User.find_by_login(params[:user_session][:login])) && @user.using_coreg_password?
      if !params[:user_session][:password].blank? && 
        (params[:user_session][:password] == params[:password_confirmation])
        @user.password = @user.password_confirmation = params[:user_session][:password]
        @user.save
        session_scoped_by_site do
          @user_session = UserSession.new(@user.reload)
        end
        if @user_session.save
          flash[:notice] = "Welcome, #{@user.name}"
          redirect_to account_setup_url

          return false
        end
      end    
    end
    session_scoped_by_site do
      @user_session = UserSession.new
    end
    
    flash[:error] = "Invalid login or passwords do not match.  Please check your input and try again."
    render :action => :choose_password
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

# $Id$
# $Id$ 
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # For Apache mod_porter (file upload optimizer)
  # Must match PorterSharedSecret value in http config virtual host
  mod_porter_secret = MOD_PORTER_SECRET
  
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem
  include ExceptionNotifiable
  include SslRequirement
  
  #RAILS_ENV = 'maintenance'
  
  # May work w/ 2.2+

  #comment this statement if you want to test the rescue page in development mode
  unless ActionController::Base.consider_all_requests_local
    rescue_from ActionController::RoutingError, ActionView::MissingTemplate,
      ActionController::UnknownAction, ActionController::UnknownController,
      ActionController::InvalidAuthenticityToken, :with => :render_404
    rescue_from ActionController::MethodNotAllowed, :with => :invalid_method
    rescue_from RuntimeError, :with => :render_500
  end
  
  helper :all # include all helpers, all the time
  
  helper_method :current_user_session, :current_user
  helper_method :current_account, :admin?
  helper_method :facebook_session
  
  before_filter :set_time_zone
  before_filter :set_locale
  before_filter :check_enable_maintenaince_mode
  before_filter :clear_js_include_cache
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery #:secret => 'ass234234lkj3-_1234lkj'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  filter_parameter_logging "password", "password_confirmation", "cc_number", "creditcard"
  # prevent a violation of Facebook Terms of Service while reducing log bloat
  filter_parameter_logging :fb_sig_friends
  
  layout :dynamic_layout

  def set_time_zone
    Time.zone = @current_user.time_zone if @current_user
  end
    
  def send_protected_content(path, type)
    # send_file with :x_sendfile => true option FAILS
    response.headers['X-Sendfile'] = path
    send_file path, :type => type, :disposition => 'inline'
  end
  
  def load_artifacts
    @artifacts = current_user.contents
  end

  # Removes form field 'hint' value from submitted value, returns 
  # modified value
  def filter_hint_form_value(field, value="")
    value.gsub(I18n.t("form.input.#{field}.hint"), "")
  end
  
  # Destroys, creates, or returns last recording (for appropriate parent)
  def build_recording(session_key)
    # Destroy last recording & associated content object if redoing
    if params[:redo]
      Recording.destroy(session[session_key]) rescue nil
      session[session_key] = nil
    end

    @recording = if session[session_key]
      begin 
        Recording.find(session[session_key])
      rescue
        session[session_key] = nil
      end
    end
    @recording ||= Recording.new
  end
  
  # Uncomment to for dev environment to simulate production
#  def local_request?
#    false
#  end
  
  def authorize
    unless admin?
      flash[:error] = "unauthorized access"
      redirect_to home_path
      false
    end
  end
  
  def admin?
    current_user.admin?
  end
  
  def member?
    current_user.member?
  end
  
  def guest?
    current_user.guest?
  end
  
  def current_account
    @current_account ||= if current_user
      current_user.account
    else
      Account.find_by_full_domain(request.host) 
    end
    raise ActiveRecord::RecordNotFound unless @current_account
    @current_account
  end
  
  def ssl_required?
    # (Comment this one line out if you want to test ssl locally)
    #return false if local_request? 
    
    # otherwise, use the filters.
    super
  end

  def ssl_prohibited 
    if request.ssl? 
      redirect_to "http://#{request.host}#{request.request_uri}"
    end 
  end 
    
  # Helper for content authorization form ajax updates
  def ajax_authorization_update(object)
    flash[:notice] = "Successfully updated authorizations."
  end
  
  # Helper to avoid checking for nil value in params
  # from http://snippets.dzone.com/posts/show/5437
  # kinda ugly...but helpful
  # Examples: 
  # => if params_check(:object)
  # => if params_check(:object, value)
  # => if params_check([:object, :attribute])
  # => if params_check([:object, :attribute], value)
  
  def params_check(*args)    
    if args.length == 1
      if args[0].class == Array
        if params[args[0][0]][args[0][1]] && !params[args[0][0]][args[0][1]].empty?
          true
        end
      else        
        if params[args[0]] && !params[args[0]].empty?
          true
        end
      end
    elsif args.length == 2
      if args[0].class == Array
        if params[args[0][0]][args[0][1]] && params[args[0][0]][args[0][1]] == args[1]
          true
        end
      else
        if params[args[0]] && params[args[0]] == args[1]
          true
        end
      end  
    end
  end
  
  # Helpers for redirections
  
  def flash_redirect(msg, *params)
    flash[:notice] = msg
    redirect_to(*params)
  end
  
  # redirect somewhere that will eventually return back to here
  def redirect_away(*params)
    session[:original_uri] = request.request_uri
    redirect_to(*params)
  end

  # returns the person to either the original url from a redirect_away or to a default url
  def redirect_back(*params)
    uri = session[:original_uri]
    session[:original_uri] = nil
    
    unless uri.nil? || uri.match(/logout/)
      RAILS_DEFAULT_LOGGER.debug "Redirecting back to #{uri}"
      redirect_to uri
    else
      RAILS_DEFAULT_LOGGER.debug "Redirecting back to #{params.to_s}" 
      redirect_to(*params)
    end
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
      
  # From using helpers in controller
  # http://snippets.dzone.com/posts/show/1799
  # Need to call number_helper ActionView method from within
  # contents controller, reuse for other helper methods.
  
  def help
    Helper.instance
  end
  
  class Helper
    include Singleton
    include ActionView::Helpers::NumberHelper
    include ActionView::Helpers::DateHelper
    include DecorationsHelper
  end
  
  private
  
  def clear_js_include_cache
    LayoutHelper.clear_js_cache
  end
  
  # Facebook Apps methods
  
  def load_facebook_connect
    Facebooker.load_configuration(File.join(RAILS_ROOT, 'config', 'facebooker.yml'))
  end
  
  def set_facebook_connect_session
    load_facebook_connect
    #set_facebook_session
    create_facebook_session
    # If user is logged in to facebook but not logged in using FB Connect,
    # destroy session info
    if @facebook_session && @facebook_session.user && current_user && 
      (current_user.facebook_id.to_s != @facebook_session.user.id.to_s)
      RAILS_DEFAULT_LOGGER.debug "Facebook user id conflict - Clearing facebook session"
      @facebook_session = nil
    end
  end
  
  def load_facebook_desktop
    Facebooker::Session.current = FacebookDesktopApp::Session.create
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def login_required
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_away new_user_session_url
      return false
    end
  end
  alias_method :require_user, :login_required
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_away account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  # TODO: Fix these in production
  def render_404
    render :template => "errors/404", :status => :not_found, :layout => false
  end

  def render_500
    render :template => "errors/500", :status => :internal_server_error, :layout => false
  end

  def check_enable_maintenaince_mode
    if RAILS_ENV == 'maintenance'
      render :template => "/errors/maintenance", :status => "maintenance", :layout => 'errors'
    end
  end
  
  def invalid_method
    message = "Now, did your mom tell you to #{request.request_method.to_s.upcase} that ?"
    render :text => message, :status => :method_not_allowed
  end
  
  def dynamic_layout
    @layout = if request.xhr? 
      nil
    elsif params[:dialog]
      'dialog'
    elsif current_user && !current_user.role.nil?
      current_user.role.downcase
    else
      'public'
    end
  end
  
  def localize
    I18n.locale = params[:locale] if params[:locale]
  end
  
  def set_locale
    I18n.locale = extract_locale_from_tld
  end
  
  # Get locale from top-level domain or return nil if such locale is not available
  # You have to put something like:
  #   127.0.0.1 application.com
  #   127.0.0.1 application.it
  #   127.0.0.1 application.pl
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    (available_locales.include? parsed_locale) ? parsed_locale  : nil
  end
  
  def available_locales; AVAILABLE_LOCALES; end
  
  # memcache handler: pass cache key and block
  def cache(key, clear=false)
    begin
      if clear
        RAILS_DEFAULT_LOGGER.info "Deleting cache key: #{key}"
        CACHE.delete(key)
      end
      
      unless output = CACHE.get(key)
        output = yield
        CACHE.set(key, output, 1.hour) unless RAILS_ENV == 'development'
      end
      output
    rescue
      yield
    end
  end
  
end
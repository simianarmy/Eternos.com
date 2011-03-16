# $Id$
# $Id$ 
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # For Apache mod_porter (file upload optimizer)
  # Must match PorterSharedSecret value in http config
  self.mod_porter_secret = MOD_PORTER_SECRET
  
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem
  include ExceptionNotification::Notifiable
  include SslRequirement
  
  #RAILS_ENV = 'maintenance'
  
  # May work w/ 2.2+

  #comment this statement if you want to test the rescue page in development mode
  unless ActionController::Base.consider_all_requests_local
    rescue_from ActionController::RoutingError, ActionView::MissingTemplate,
      ActionController::UnknownAction, ActionController::UnknownController,
      ActionController::InvalidAuthenticityToken, :with => :render_404
    rescue_from ActionController::MethodNotAllowed, :with => :invalid_method
    rescue_from Facebooker::Session::IncorrectSignature, :with => :invalid_facebook_signature
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
  before_filter :set_site_id
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery #:secret => 'ass234234lkj3-_1234lkj'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  filter_parameter_logging "password", "password_confirmation", "number", "cc_number", "creditcard", "fb_sig_friends"
  
  layout :dynamic_layout

  def set_site_id
    @siteID = Account::Site.id_from_subdomain(current_subdomain)
  end
  
  def invalid_facebook_signature
    redirect_to logout_url 
  end

  # Required for Facebooker integration
  def verify_authenticity_token
    super unless request_comes_from_facebook?
  end
  
  def set_time_zone
    Time.zone = @current_user.time_zone if @current_user
  end
    
  def load_member_home_presenter
    # Create home presenter object
    @settings = MemberHomePresenter.new(current_user)
  end

  # THIS DOESN'T WORK..
  def send_protected_content(path, type)
    # send_file with :x_sendfile => true option FAILS
    response.headers['X-Sendfile'] = path
    RAILS_DEFAULT_LOGGER.debug "Streaming url #{path} with type #{type}"
    send_file path, :type => type, :disposition => 'inline'
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
    
    # AVOID REDIRECTING BACK IF BACK = PUBLIC AREA - IT WILL CONFUSE THE SHIT OUT OF USERS!
    unless uri.nil? || uri.match(/about|user_sessions|login|logout|signup|vlogin|vlogout/)
      RAILS_DEFAULT_LOGGER.debug "Redirecting back to #{uri} from #{uri}"
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
      
  def hide_feedback_tab
    @hide_feedback = true
  end
  
  # Memcache helpers
  
  def force_cache_reload?(key)
    session["nocache_#{key.to_s}"]
  end
  
  def force_cache_reload!(*keys)
    keys.each { |k| session["nocache_#{k.to_s}"] = true }
  end
  
  def use_cache!(key)
    session["nocache_#{key.to_s}"] = nil
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
  
  protected
  
  def clear_js_include_cache
    LayoutHelper.clear_js_cache
  end
  
  # Facebook Apps methods
  
  def load_facebook_connect
    Facebooker.load_configuration(File.join(RAILS_ROOT, 'config', 'facebooker.yml'))
  end
  
  # Creates facebook session from custom backup app.
  def load_facebook_desktop
    Facebooker::Session.current = FacebookBackup::Session.create(facebook_app_config_path)
  end
  
  # Returns app-specific facebook config (yml) path
  # App used is based on app subdomain (defaults to 'www' app)
  def facebook_app_config_path
    case current_subdomain
    when 'vault'
      FacebookBackup::Vault.config_path
    else
      FacebookBackup.config_path
    end
  end
  
  def load_facebook_session
     @facebook_session = Facebooker::Session.current
     Rails.logger.debug "FB session => #{@facebook_session.inspect}"
  end
  
  # Helper to create & save facebook connect session
  def set_facebook_connect_session
    load_facebook_connect
    #set_facebook_session
    create_facebook_session
    Rails.logger.debug "*** create_facebook_session returned with #{@facebook_session.inspect}"
    
    # If user is logged in to facebook but not logged in using FB Connect,
    # destroy session info
    if @facebook_session && @facebook_session.user && current_user && !current_user.facebook_id.blank? &&
      (current_user.facebook_id.to_s != @facebook_session.user.id.to_s)
      Rails.logger.debug "current user facebook id #{current_user.facebook_id} != facebook session id #{@facebook_session.user.id}"
      Rails.logger.debug "Facebook user id conflict - Clearing facebook session"
      flash[:error] = "This facebook account is in use by another Eternos account."
      @facebook_session = nil
    end
  end
  
  # Helper to create & save facebook desktop session
  def set_facebook_desktop_session
    load_facebook_desktop
    load_facebook_session
  end
    
  # Scoped session helper method.  Will wrap a block inside UserSession.with_scope 
  # used to scope accounts to a site
  def session_scoped_by_site
    site_id = Account::Site.id_from_subdomain current_subdomain
    UserSession.with_scope(:find_options => {:conditions => "site_id = #{site_id}"}, :id => "account_#{site_id}") do
      yield
    end
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
  
    session_scoped_by_site do
      @current_user_session = UserSession.find
    end
    @current_user_session
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def login_required
    # If not authenticated
    unless current_user
      # Try Facebook Connect login
      set_facebook_connect_session
      if facebook_session
        Rails.logger.debug "Logging in from Facebook session"
        @current_user = User.find_by_fb_user(facebook_session.user)
      end
      flash_access_denied unless @current_user
    end
  end
  alias_method :require_user, :login_required
  
  def require_no_user
    if current_user.try(:member?)
      RAILS_DEFAULT_LOGGER.debug "require_no_user invoked"
      flash[:error] = "You must be logged out of Eternos to access this page"
      redirect_away root_url
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
  
  # For role_requirement plugin
  def access_denied
    RAILS_DEFAULT_LOGGER.debug "access_denied sending to flash_access_denied"
    flash_access_denied
  end
  
  def flash_access_denied
    store_location
    flash[:notice] = "You must be logged in to access this page"
    redirect_away login_url(:protocol => 'http')
    return false
  end
  
  # Default controller method for determining what view layout to use 
  # when rendering action.  Applies to public & logged in users, 
  # www and vault subdomains, and ajax/popup actions!
  def dynamic_layout
    # ALL THIS SUCKS, I KNOW..
    
    # No layout for AJAX calls
    @layout = if request.xhr? 
      nil
    # dialog param = lightview popup
    elsif params[:dialog]
      'dialog'
    # uses user 'role' name for layout ... bad
    elsif current_user && !current_user.role.nil?
      current_user.role.downcase
    # no user, check for 'about' action
    elsif controller_name == 'about'
      'about'
    # none of the above, use Rails default
    else
      'home'
    end
    return nil unless @layout
    
    Rails.logger.debug "Dyamic layout = #{@layout}"
    # Layouts further divided by site subdomain: www vs vault
    if current_subdomain == 'vault'
      # Then public vs logged in...ugh
      if current_user
        @layout = 'vault/private/' + @layout
      else
        @layout = 'vault/public/' + @layout
      end
    end
    @layout
  end
  
  def localize
    I18n.locale = params[:locale] if params[:locale]
  end
  
  def set_locale
    session[:locale] = locale = params[:locale] || extract_locale_from_tld || I18n.default_locale
    I18n.locale = locale.to_sym
    RAILS_DEFAULT_LOGGER.debug "I18n locale = #{I18n.locale}"
  end
  
  # Get locale from top-level domain or return nil if such locale is not available
  # You have to put something like:
  #   127.0.0.1 application.com
  #   127.0.0.1 application.it
  #   127.0.0.1 application.pl
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    (I18n.available_locales.include? parsed_locale) ? parsed_locale  : nil
  end
  
  def log_exception(msg, e)
    RAILS_DEFAULT_LOGGER.error "#{msg}: #{e.class.name} #{e.message}"
  end
end

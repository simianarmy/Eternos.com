# $Id$
class HomeController < ApplicationController
  #before_filter :redirect_if_logged_in, :only => :index
  caches_page :blog_header_partial, :blog_header_footer
  
  layout 'public'
  
  def new
    @user = User.new
  end
  
  def index
    @hide_feedback = true
    
    # Serve Facebook app home page from here
    if request_comes_from_facebook?  
      ensure_authenticated_to_facebook  
      return false unless facebook_session
      
      @fb_user_info = FacebookUserProfile.populate(facebook_session.user)
      @fb_birthdate = FacebookUserProfile.parse_model_date(@fb_user_info[:birthday_date]) || Date.today
      Rails.logger.debug "FB user info => #{@fb_user_info.inspect}"
      Rails.logger.debug "Birthday: #{@fb_birthdate.inspect}"
      @user = User.new(:first_name => @fb_user_info[:first_name], :last_name => @fb_user_info[:last_name], 
        :facebook_id => @facebook_session.user.id, :facebook_referrer => params[:from])
      @user.profile = Profile.new(:birthday => @fb_birthdate)
      
      render :layout => false and return false
    else
      set_facebook_connect_session
    end
  end
  
  def show
    @hide_feedback = true
    render :action => params[:page]
  end
  
  def blog_header_partial
    @blog = true
    render :partial => 'shared/public_header'
  end
  
  def blog_footer_partial
    render :partial => 'shared/site_footer'
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

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
    
    if request_comes_from_facebook?
      ensure_application_is_installed_by_facebook_user or return false

      if facebook_session && facebook_session.secured?
        @fb_user_info = FacebookUserProfile.populate(facebook_session.user)
        @fb_user_id = facebook_session.user.id
      else
        @fb_user_info = {}
        @fb_user_id = params[:fb_sig_user]
      end
      # If the facebook ID matches a member
      if @fb_user_id && @user = Member.from_facebook(@fb_user_id)
        # Redirect to the Facebook fan page
        redirect_to FACEBOOK_FAN_PAGE and return false
      else
        @user = User.new(:first_name => @fb_user_info[:first_name], :last_name => @fb_user_info[:last_name], 
        :facebook_id => @fb_user_id, :facebook_referrer => params[:from])
        @fb_birthdate = @fb_user_info[:birthday] || Date.today
        @user.profile = Profile.new(:birthday => @fb_birthdate)
        
        render :layout => false and return false
      end
      Rails.logger.debug "Facebook app user = #{@user.inspect} "
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

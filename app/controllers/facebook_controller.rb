# $Id$

class FacebookController < ApplicationController
  #before_filter :ensure_authenticated_to_facebook
  #before_filter :ensure_application_is_installed_by_facebook_user
  layout nil
  
  # This is the page @ http://apps.facebook.com/appname
  def index
    # Serve Facebook app home page from here

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
    end
    Rails.logger.debug "Facebook app user = #{@user.inspect} "
  end
end

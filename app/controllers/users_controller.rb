# $Id$
class UsersController < ApplicationController
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :require_no_user, :only => [:new, :create]
  
  # render new.rhtml
  def new
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.recipient_email if @user.invitation
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.login = @user.email
    @user.send_signup_notification = true
    
    @user.register! if @user.valid?
    if @user.errors.empty?
      #self.current_user = @user
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def activate
    @user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    
    # Now that we activate automatically, this is really just to confirm email addresses.
    if @user
      # We now have to support both cases since we activate automatically
      if @user.pending?
        @user.activate!
      else
        @user.email_activation_received!
      end
      # Check if this email already sent once
      unless UserMailing.count_by_email_and_subject(@user.email, UserMailer.subject(:activation)) > 0
        UserMailer.deliver_activation!(@user)
      end
      
      flash[:notice] = "Your account has been activated!"
      redirect_to account_setup_path
    else
      flash[:notice] = "Sorry, we could not activate this account"
      redirect_back_or_default('/')
    end
  end

  def link_user_accounts
    if self.current_user.nil?
      #register with fb
      flash_redirect("Unable to login from Facebook", login_path) unless User.create_from_fb_connect(facebook_session.user)
      return
    else
      #connect accounts
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.facebook_uid == facebook_session.user.id
    end
    redirect_back_or_default('/')
  end
  
  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

protected
  
  def find_user
    @user = User.find(params[:id])
  end
  
end

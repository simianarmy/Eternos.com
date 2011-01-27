# $Id$

class AccountSetupController < ApplicationController
  before_filter :load_fb_user_using_perishable_token, :only => [:show]
  before_filter :login_required
  require_role "Member"
  
  before_filter :load_completed_steps
  before_filter :load_facebook_app_session
  before_filter :load_presenter
   
  layout :subdomain_layout
  
  ssl_required :all
  
  def show
    session[:setup_account] = true

    # Dynamic action view based on current setup step - stupid
    Rails.logger.debug "ACTIVE STEP = #{@active_step}"
    Rails.logger.debug "SETUP STEP = #{@completed_steps}"
    if @active_step <= 1
      load_online
      @content_page = 'backup_sources'
    elsif @active_step == 2 && current_subdomain != 'vault'
      # Get list of facebook ids of friends that have joined after invites from this user
      @already_invited = current_user.facebook_id ? 
        Member.find_all_by_facebook_referrer(current_user.facebook_id).map(&:facebook_id).compact : []

      # This should be the invite page now..
      @content_page = 'invite_others'
    else 
      flash[:notice] = "Account Setup Complete!"
      return redirect_to member_home_path
    end
  
    respond_to do |format|
      format.html
      format.js
    end
  end

  # TODO: Move to Feeds controller
  def set_feed_rss_url
    begin
      @feed = current_user.backup_sources.blog.find(params[:id])
      @feed.rss_url = params[:value]
      if @feed.save
        current_user.completed_setup_step(1)
        render :text => @feed.send(:rss_url).to_s
      else
        render :text => @feed.errors.full_messages
      end
    rescue Exception => e
      render :text => e.to_s
    end
  end
  
  def backup_sources
    load_online
    
    respond_to do |format|
      format.js {
        render :update do |page|
          update_account_setup_layout(page, "backup_sources")
        end
      }
    end
  end
  
  def invite_others
    current_user.completed_setup_step(2)
    invite_url = new_account_url(:plan => AppConfig.default_plan)
    sent = false
    
    # If sending facebook invites
    if params[:ids]
      # Save friends list to prevent from showing up later?
    else # Otherwise sending invites from form
      # Use sendmail to send so that From can be set correctly (Google Apps won't allow it)
      og_delivery_method = ActionMailer::Base.delivery_method
      ActionMailer::Base.delivery_method = :sendmail
    
      1.upto(4) do |i|
        email = params["email_#{i}"]
        unless email.blank?
          sent = true
          spawn { 
            UserMailer.deliver_friend_invite(current_user, email, invite_url) 
          }
        end
      end
      # Set mailer delivery back to default
      ActionMailer::Base.delivery_method = og_delivery_method
    end
    
    respond_to do |format|
      format.html {
        flash[:notice] = "Account setup complete" if @completed_steps > 0
        redirect_to member_home_path
      }
    end
  end

  protected
  
  # Determine layout for public or corporate user
  def subdomain_layout
    # Layouts further divided by site subdomain: www vs vault
    if current_subdomain == 'vault'
      # Further divided into public & logged-in layouts
      if current_user.setup_step == 0
        @layout = 'vault/public/account_setup'
      else
        @layout = 'vault/private/account_setup'
      end
    else
      @layout = 'account_setup'
    end
    @layout
  end
  
  # Check for one-time access token in user account & logs in user if found
  # Used for Facebook app Canvas / App server single-sign on
  def load_fb_user_using_perishable_token
    if params[:id]
      if @current_user = User.find_using_perishable_token(params[:id])
        Rails.logger.debug "Logging in from perishable token (user #{@current_user.id})"
        UserSession.create(@current_user) # Is this necessary?
      end
    end
  end
  
  def load_facebook_app_session
    if @active_step == 2
      set_facebook_connect_session
    else
      set_facebook_desktop_session
    end
  end
  
  def load_completed_steps
    @active_step = params[:step] ? params[:step].to_i : 1
    @completed_steps = current_user.setup_step
  end

  def load_online
    @settings.load_facebook_user_info
    @settings.create_fb_login_url(request)
  end

  def respond_to_ajax_remove(obj)
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "#{obj.to_str}_#{obj.id}"
        end
      end
    end
  end

  def load_presenter
    Rails.logger.debug "Creating SetupPresenter with session => #{@facebook_session.inspect}"
    @settings = SetupPresenter.new(current_user, @facebook_session, params)
    @settings.load_backup_sources
  end
end

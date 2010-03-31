# $Id$

class AccountSetupController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  before_filter :load_facebook_desktop
  before_filter :load_facebook_session
  before_filter :load_presenter
  before_filter :load_completed_steps
  
  ssl_required :all
  
  def show
    session[:setup_account] = true
    
    # Dynamic action view based on current setup step - stupid
    if @completed_steps < 2
      load_online
      @content_page = 'backup_sources'
    elsif @completed_steps == 2
      # This should be the invite page now..
      @content_page = 'invite_others'
    else 
      flash[:notice] = "Account Setup Complete!"
      return redirect_to member_home_path
    end
    @active_step = @completed_steps.to_i + 1
    
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
        current_user.completed_setup_step(2)
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
    
    respond_to do |format|
      format.html {
        flash[:notice] = "Account Setup Complete!"
        redirect_to member_home_path
      }
    end
  end
  
  private
   
   def load_completed_steps
     @completed_steps = params[:step].to_i || current_user.setup_step || 0
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
     @settings = SetupPresenter.new(current_user, load_facebook_session, params)
     @settings.load_backup_sources
   end
end

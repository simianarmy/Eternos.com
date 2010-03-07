# $Id$

class AccountSetupController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  before_filter :load_facebook_desktop
  before_filter :load_facebook_session
  before_filter :load_presenter
  before_filter :load_completed_steps
  
  ssl_required :show, :save_personal_info, :backup_sources, :personal_info
  
  def show
    session[:setup_account] = true
    
    # Dynamic action view based on current setup step
    @content_page = if @completed_steps == 0
      load_online
      'backup_sources'
    else
      # This should be the invite page now..
      @settings.load_personal_info
      #'personal_info'
      'invite_others'
    end
    @active_step = @completed_steps.to_i + 1
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  # TODO: Move to profile controller
  def save_personal_info
    @settings.load_personal_info
    
    if @settings.update_personal_info
      if @settings.has_required_personal_info_fields?
        @current_step = current_user.setup_step
        current_user.completed_setup_step(1)
        flash[:notice] = "Personal Info Saved"
      else
        flash[:error] = "Please fill in all required fields"
      end
    else
      flash[:error] = "Unable to save your changes: <br/>" + @settings.errors.join('<br/>')
    end
    
    respond_to do |format|
      format.js {
        render :update do |page|
          # On 1st successful save, we want to refresh page to next step
          unless flash[:error] || (@completed_steps > 0)
            page.redirect_to :action => 'index'
          else
            page.show_flash
          end
        end
      }
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
  
  def personal_info
    @settings.load_personal_info
    
    respond_to do |format|
      format.js do
        render :update do |page|
          update_account_setup_layout(page, "personal_info")
        end
      end
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
  
  private
   
   def load_completed_steps
     @completed_steps = params[:step].to_i || current_user.setup_step || 0
   end
   
   def load_online
     @settings.load_backup_sources
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
   
   def load_facebook_session
     @fb_session ||= Facebooker::Session.current
   end
   
   def load_presenter
     @settings = SetupPresenter.new(current_user, load_facebook_session, params)
   end
end

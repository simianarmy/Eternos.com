# $Id$

class Vault::Accounts::BackupsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  before_filter :load_completed_steps
  before_filter :load_facebook_app_session
  before_filter :load_presenter
   
  layout 'vault/private/account_setup'
  
  ssl_required :all
  
  def index
    session[:setup_account] = true

    # Dynamic action view based on current setup step - stupid
    Rails.logger.debug "ACTIVE STEP = #{@active_step}"
    
    load_online
    @content_page = 'backup_sources'
  
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

  protected
  
  def load_facebook_app_session
    set_facebook_desktop_session
  end
  
  def load_completed_steps
    @completed_steps = current_user.setup_step
  end

  def load_online
    @settings.load_facebook_user_info
    @settings.fb_login_url = @facebook_session.login_url_with_perms
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
    Rails.logger.debug "Creating Vault Backup Presenter"
    @settings = Vault::BackupPresenter.new(current_user, @facebook_session, params)
    @settings.load_backup_sources
  end
end

# $Id$

class AccountSetupController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :load_facebook_desktop
  before_filter :load_facebook_session
  before_filter :load_completed_steps
  layout 'account_setup'
  
  def show
    session[:setup_account] = true
    
    # Dynamic action view based on current setup step
    @content_page = if @completed_steps > 0
      load_online
      'backup_sources'
    else
      find_user_profile
      'personal_info'
    end
    @active_step = @completed_steps + 1
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  # TODO: Move to profile controller
  def save_personal_info
    find_user_profile
    initialize_from_params
    
    if update_personal_info 
      if has_required_personal_info_fields?
        @current_step = current_user.setup_step
        current_user.completed_setup_step(1)
        flash[:notice] = "Name & Birthdate Saved"
      else
        flash[:error] = "Please fill in all required fields"
      end
    else
      flash[:error] = "Unable to save your changes: <br/>" + @errors.join('<br/>')
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
  
  # TODO: Move to RSS controller
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
    find_user_profile
    respond_to do |format|
      format.js do
        render :update do |page|
          update_account_setup_layout(page, "personal_info")
        end
      end
    end
  end
  
  def load_online
    # Desktop login url 
    # Using url described on http://wiki.developers.facebook.com/index.php/Authorization_and_Authentication_for_Desktop_Applications#Prompting_for_Permissions
    @fb_login_url = @fb_session.login_url_with_perms(
      :next => authorized_facebook_backup_url(:host => request.host), 
      :next_cancel => cancel_facebook_backup_url(:host => request.host)
      )
    
    @feed_url = FeedUrl.new
    
    backup_sources = current_user.backup_sources
    if backup_sources.any?
      if @facebook_account = backup_sources.facebook.first
        if @facebook_confirmed = @facebook_account.confirmed?
          begin
            current_user.facebook_session_connect @fb_session
            @fb_session.user.populate(:pic_small, :name) if @fb_session.verify
            @facebook_user = @fb_session.user
          end
        end
      else
        @facebook_confirmed = false
      end
      @twitter_accounts = backup_sources.twitter.paginate :page => params[:page], :per_page => 10
      @twitter_account   = backup_sources.twitter.first
      @twitter_confirmed = @twitter_account && @twitter_account.confirmed?
      @feed_urls = current_user.backup_sources.blog.paginate :page => params[:page], :per_page => 10
      @rss_url = backup_sources.blog.first
      @rss_confirmed = @rss_url && @rss_url.confirmed?
      load_email_accounts
      @current_gmail = @email_accounts.first
    end
  end
  
  def backup_sources
    load_online
    
    respond_to do |format|
      format.js {
        render :update do |page|
          if params[:page].blank?
            update_account_setup_layout(page, "backup_sources")
          else
            page.replace_html 'result-urls', :partial => 'backup_sources/rss_url_list', 
              :locals => {:feed_urls => @feed_urls}
          end
        end
      }
    end
  end
  
  private

   def update_personal_info
     @errors = []
     unless current_user.profile.update_attributes(@new_profile)
      @errors = current_user.profile.errors.full_messages
      return false
    end
    unless current_user.address_book.update_attributes(@new_address_book)
      @errors = current_user.address_book.errors.full_messages
    end
    @errors.empty?
   end
   
   def has_required_personal_info_fields?
     (ab = current_user.address_book) &&
     !ab.first_name.blank? && !ab.last_name.blank? && ab.birthdate
   end
   
   def initialize_from_params
     @new_address_book = params[:address_book]
     @new_profile = params[:profile]
   end
   
   def find_user_profile
      @address_book = current_user.address_book
      @profile  = current_user.profile
   end
   
   def load_email_accounts
     @email_accounts = current_user.backup_sources.gmail.paginate :page => params[:page], :per_page => 10
   end
   
   def load_completed_steps
     @completed_steps = current_user.setup_step
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
     @fb_session = Facebooker::Session.current
   end
end

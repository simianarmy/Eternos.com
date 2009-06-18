# $Id$

class AccountSettingsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :set_facebook_session
  
  def index
    find_user_profile
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def personal_info
    find_user_profile
    respond_to do |format|
      format.js do
        render :update do |page|
          setup_layout_account_setting(page, "step1", "account_settings/personal_info")
        end
      end
    end
  end

  #still in progress
  def facebook_sync
    find_user_profile
    saved = false
    if facebook_session && (fb_user = facebook_session.user)
      if fb_user.populate(*Facebooker::User::FIELDS)
        
        facebook_profile = {}
        Facebooker::User::FIELDS.each {|f| facebook_profile[f] = fb_user.send(f)}
        @new_address_book, @new_profile = FacebookProfile.convert_fb_profile_to_sync_with_local_setup(facebook_profile)
        saved = update_personal_info
      end
    end
   
    respond_to do|format|
      if saved
        format.js do
          render :update do |page|
            @sync_message = "Sync Successfull"
            setup_layout_account_setting(page, "step1", "account_settings/personal_info")
            page.replace "sync-message", :partial => "account_settings/sync_message"
            page.visual_effect :highlight, "sync-message"
          end
        end  
      else
        format.js do
          render :update do |page|
            @sync_message = "Can't sync with facebook"
            page.replace "sync-message", :partial => "account_settings/sync_message"
            page.visual_effect  :highlight, "sync-message"
          end
        end
      end
    end
    
  rescue
     respond_to do|format|
        format.js do
          render :update do |page|
            @sync_message = "Can't sync with facebook"
            page.replace "sync-message", :partial => "account_settings/sync_message"
            page.visual_effect :highlight, "sync-message"
          end
        end
    end
  end

  def online
    @online_account = BackupSource.new
    respond_to do |format|
      format.js do
        render :update do |page|
          setup_layout_account_setting(page, "step2", "account_settings/online")
        end
      end
    end  
  end

  def email_account
    respond_to do |format|
      format.js do
        render :update do |page|
          setup_layout_account_setting(page, "step3", "account_settings/email_account")
        end
      end
    end  
  end

  def upgrades
    respond_to do |format|
      format.js do
        render :update do |page|
          setup_layout_account_setting(page, "step5", "account_settings/upgrades")
        end
      end
    end
  end

  def billings
    respond_to do |format|
      format.js do
        render :update do |page|
          setup_layout_account_setting(page, "step6", "account_settings/billings")
        end
      end
    end
  end

  def save_personal_info
    find_user_profile
    initialize_from_params
    respond_to do |format|
      if update_personal_info
        format.js {
          flash[:notice] = "Personal Info Saved";
          render :nothing => true
        }
      else
        format.js {
          flash[:error] = "Something wrong !"
          render :nothing => true
        }
      end

    end 
    
  end
  
  private

   def update_personal_info
     rv = false
     if @profile and !@new_profile.empty? and @address_book and !@new_address_book.empty?
       if @profile.update_attributes(@new_profile) && @address_book.update_attributes(@new_address_book)
         rv = true
       end
     end
     return rv
   end
   
   def initialize_from_params
     @new_address_book = params[:address_book]
     @new_profile = params[:profile]
   end
   
   def find_user_profile
      @user = current_user
      @address_book = @user.address_book
      @profile  = Profile.find_or_create_by_user_id(@user.id)
   end

end
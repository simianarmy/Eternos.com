# $Id$

class AccountSettingsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :load_facebook
  before_filter :load_presenter
  before_filter :load_completed_steps
  layout 'account_settings'
  
  def index
#    check_facebook_sync
    clear_timeline_cache
    session[:setup_account] = true
    
    # Dynamic action view based on current setup step
    @content_page = case @completed_steps
    when 0
      @settings.load_personal_info
      'personal_info'
    else
      @settings.load_history
      'your_history'
    end
#    @active_step = [@completed_steps+1, 3].min
    @active_step = @completed_steps + 1
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def personal_info
    @settings.load_personal_info
    
    respond_to do |format|
      format.js do
        render :update do |page|
          update_account_settings_layout(page, "personal_info")
        end
      end
    end
  end
  
  def your_history
    @settings.load_history
    
    respond_to do |format|
      format.js do
        render :update do |page|
          update_account_settings_layout(page, "your_history")
        end
      end
    end  
  end
   
  # For the ajax api
  def completed_steps
    respond_to do |format|
      format.js {
        render :inline => current_user.setup_step
      }
    end  
  end

  # TODO: Move to FacebookProfiles controller
  def always_sync_with_facebook
    if params[:facebook_sync]
      save = current_user.update_attribute(:always_sync_with_facebook, true)
    else
      save = current_user.update_attribute(:always_sync_with_facebook, false)
    end
    respond_to do |format|
      format.js do
        if save
          render :nothing => true
        else
          render :update do |page|
             @sync_message = "Can't set reminder for facebook sync"
             page.replace "sync-message", :partial => "account_settings/sync_message"
             page.visual_effect :highlight, "sync-message"
          end
        end
      end
    end
  end

  # TODO: Move to FacebookProfiles controller
  def facebook_sync
    saved = merge_with_facebook
    respond_to do|format|
      if saved
        format.js do
          render :update do |page|
            @sync_message = "Sync Successfull"
            update_account_settings_layout(page, "personal_info")
            page.replace "sync-message", :partial => "sync_message"
            page.visual_effect :highlight, "sync-message"
          end
        end  
      else
        format.js do
          render :update do |page|
            @sync_message = "Can't sync with facebook"
            page.replace "sync-message", :partial => "sync_message"
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
            page.replace "sync-message", :partial => "sync_message"
            page.visual_effect :highlight, "sync-message"
          end
        end
    end
  end
  
  # TODO: Move to AddressBooks controller
  def new_address
    @address_book = current_user.address_book
    
    respond_to do |format|
      if @address_book.update_attributes(params[:address_book]) && @address_book.valid?
        @address = @address_book.addresses.reload.last
        flash[:notice] = "Address Book succesfully updated"
        format.js
      else
        format.js {
          @address = @address_book.addresses.last
          flash[:error] = @address_book.errors.full_messages.reject{|err| err == 'is invalid'}.uniq.join('<br/>')
        }
      end
    end
  end
  
  # TODO: Move to Addresses controller
  def remove_address
    begin
      @address = current_user.address_book.addresses.find(params[:id])
      @address.destroy
    end
    
    respond_to_ajax_remove @address
  end

  # TODO: Move to Jobs controller
  def new_job
    @job = current_user.profile.careers.new(params[:job])
    @job.save
    
    respond_to do |format|
      if !@job.new_record?
        flash[:notice] = "Job added"
        format.html
        format.js
      else
        format.js {
          flash[:error] = @job.errors.full_messages.join('<br/>')
        }
        format.html
      end
    end
  end
  
  # TODO: Move to Jobs controller
  def remove_job
    begin
      @job = current_user.profile.careers.find(params[:id])
      @job.destroy
    end
    
    respond_to_ajax_remove @job
  end
  
  # TODO: Move to Schools/Education controller
  def new_school
    @school = current_user.profile.schools.new(params[:school])
    @school.save
    
    respond_to do |format|
      if !@school.new_record?
        flash[:notice] = "School added"
        format.html
        format.js
      else
        format.js {
          flash[:error] = @school.errors.full_messages.join('<br/>')
        }
        format.html
      end
    end
  end
  
  # TODO: Move to Schools/Education controller
  def remove_school
    begin
      @school = current_user.profile.schools.find(params[:id])
      @school.destroy
    end
    
    respond_to_ajax_remove @school
  end
  
  # TODO: Move to appropriate controller
  def new_medical
    @medical = current_user.profile.medicals.new(params[:medical])
    @medical.save
    
    respond_to do |format|
      if !@medical.new_record?
        flash[:notice] = "Medical Info added"
        format.html
        format.js
      else
        format.js {
          flash[:error] = @medical.errors.full_messages.join('<br/>')
        }
        format.html
      end
    end
  end
  
  # TODO: Move to appropriate controller
  def remove_medical
    begin
      @medical = current_user.profile.medicals.find(params[:id])
      @medical.destroy
    end
    
    respond_to_ajax_remove @medical
  end
  
  # TODO: Move to appropriate controller
  def new_medical_condition
    begin
      params[:medical_conditions].each_value do |val|
        @medical_condition = MedicalCondition.new(val.merge(:profile_id => current_user.profile.id))
        @medical_condition.save!
      end

      @settings.find_medical_condition
      render :update do |page|
        page.remove "table-form-medical-condition"
        page.insert_html :bottom, "table-form-medical-condition-wrapper", "<div id=\"table-form-medical-condition\"></div>"
        page.hide "save-button-medical-condition"
        page.replace_html "table-medical-conditions", :partial => 'new_medical_condition', 
          :locals => {:medical_conditions => @settings.medical_conditions}
      end
    rescue ActiveRecord::ActiveRecordError
      render :update do |page|
        page.replace_html "error-message-medical-condition", :inline => "<%= error_messages_for 'medical_condition' %>"
        page[:errorExplanation].visual_effect :highlight,
                                              :startcolor => "#ea8c8c",
                                              :endcolor => "#cfe9fa"
        page.delay(4) do
          page[:errorExplanation].remove                            
        end
      end    
    end
  end
  
  # TODO: Move to appropriate controller
  def remove_medical_condition
    begin
      @medical_condition = current_user.profile.medical_conditions.find(params[:id])
      @medical_condition.destroy
    end
    
    respond_to_ajax_remove @medical_condition
  end
  
  # TODO: Move to appropriate controller
  def new_family
    begin
      params[:families].each_value do |val|
        birtdate = Time.local(val[:birtdate_year],val[:birtdate_month],val[:birtdate_day])
        val.merge!(:profile_id => current_user.profile.id, :birthdate => birtdate)
        val.delete_if{|k, v| ["birtdate_year", "birtdate_month", "birtdate_day"].include?(k)}
        @family = Family.new(val)
        @family.save!
      end

      @settings.find_family
      render :update do |page|
        page.remove "table-form-family"
        page.insert_html :bottom, "table-form-family-wrapper", "<div id=\"table-form-family\"></div>"
        page.hide "save-button-family"
        page.replace_html "table-families", :partial => 'new_family', :locals => {:families => @settings.families}
      end
    rescue ActiveRecord::ActiveRecordError
      render :update do |page|
        page.replace_html "error-message-family", :inline => "<%= error_messages_for 'family' %>"
        page[:errorExplanation].visual_effect :highlight,
                                              :startcolor => "#ea8c8c",
                                              :endcolor => "#cfe9fa"
        page.delay(4) do
          page[:errorExplanation].remove                            
        end
      end   
    end
  end
  
  # TODO: Move to appropriate controller
  def remove_family
    begin
      @family = current_user.profile.families.find(params[:id])
      @family.destroy
    end
    
    respond_to_ajax_remove @family
  end
  
  # TODO: Move to appropriate controller
  def new_relationship
    @relationship = current_user.relationships.new(params[:relationship])
    @relationship.end_at = nil if params[:current] == '1'

    begin
      if @relationship.save
        flash[:notice] = "Relationship saved"
      else
        flash[:error] = @relationship.errors.full_messages.join('<br/>')
      end
    rescue
      flash[:error] = "Unexpected error saving relationship: " + $!
    end

    respond_to do |format|
      format.js # why isn't his working???
    end
  end
  
  # TODO: Move to appropriate controller
  def remove_relationship
    begin
      @relationship = current_user.relationships.find(params[:id])
      @relationship.destroy
    end
    
    respond_to_ajax_remove @relationship
  end
  
  # TODO: Move to appropriate controller
  def upgrades
    respond_to do |format|
      format.js do
        render :update do |page|
          update_account_settings_layout(page, "account_settings/upgrades")
        end
      end
    end
  end

  # TODO: Move to appropriate controller
  def billings
    respond_to do |format|
      format.js do
        render :update do |page|
          update_account_settings_layout(page, "account_settings/billings")
        end
      end
    end
  end

  # TODO: Move to appropriate controller
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
      format.js
    end 
  end
  
  private
  
  def load_completed_steps
    @completed_steps = current_user.setup_step
  end
  
  # Load facebook Connect or Desktop app based on action
  def load_facebook
    if %w[ online ].include?(params[:action])
      RAILS_DEFAULT_LOGGER.debug "Loading Facebook Desktop App"
      load_facebook_desktop
    else
      RAILS_DEFAULT_LOGGER.debug "Loading Facebook Connect App"
      load_facebook_connect
    end
  end
  
  def load_presenter
    @settings = ProfilePresenter.new(current_user, Facebooker::Session.current, params)
  end

  def check_facebook_sync
    if current_user.always_sync_with_facebook
      @checked_always_sync = true
      merge_with_facebook
    end
  end

  def merge_with_facebook
    saved = false
    if facebook_session && (fb_user = facebook_session.user)
      facebook_profile = FacebookUserProfile.populate(fb_user)
      @new_address_book, @new_profile = FacebookProfile.convert_fb_profile_to_sync_with_local_setup(facebook_profile)
      saved = @settings.update_personal_info
    end
    return saved
  end
   
   # If account settings change causes timeline data to update, we need the timeline
   # to refresh
   def clear_timeline_cache
     session[:refresh_timeline] = true
   end
   
   def respond_to_ajax_remove(obj)
     respond_to do |format|
       format.js do
         render :update do |page|
           page["#{obj.to_str}_#{obj.id}"].highlight
           page["#{obj.to_str}_#{obj.id}"].fade :duration => 1
         end
       end
     end
   end
end
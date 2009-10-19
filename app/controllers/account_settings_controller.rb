# $Id$

require 'settings_presenter'

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

  # For the ajax api
  def completed_steps
    respond_to do |format|
      format.js {
        render :inline => current_user.setup_step
      }
    end  
  end
  
  # TODO: Move to RSS controller
  def set_feed_rss_url
    begin
      @feed = current_user.backup_sources.by_site(BackupSite::Blog).find(params[:id])
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

  # TODO: Move to FacebookProfiles controller
  def facebook_sync
    find_user_profile
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
  
  def online
    load_online
    
    respond_to do |format|
      format.js {
        render :update do |page|
          update_account_settings_layout(page, "backup_sources")
        end
      }
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
  
  # TODO: Move to AddressBooks controller
  def new_address
    @address_book = current_user.address_book
    
    respond_to do |format|
      if @address_book.update_attributes(params[:address_book]) && 
        @address_book.valid?
        @address = @address_book.addresses.reload.last
        flash[:notice] = "Address Book succesfully updated"
        format.js
      else
        format.js {
          flash[:error] = @address_book.errors.full_messages.reject{|err| err == 'is invalid'}.join('<br/>')
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
  def add_another_job
    begin
      params[:jobs].each_value do |val|
        start_at = Time.local(val[:start_year],val[:start_month],val[:start_day])
        end_at = Time.local(val[:end_year],val[:end_month],val[:end_day]) unless val[:end_year].nil? 
        val.merge!(:profile_id => current_user.profile.id, :start_at => start_at, :end_at => end_at)
        val.delete_if{|k, v| ["start_year", "start_month", "start_day", "end_year", "end_month", "end_day"].include?(k)}
        @job = Job.new(val)
        @job.save!
      end

      @settings.find_job
      render :update do |page|
        page.remove "table-form-job"
        page.insert_html :bottom, "table-form-job-wrapper", "<div id=\"table-form-job\"></div>"
        page.hide "save-button-job"
        page.replace_html "table-jobs", :partial => 'new_job', :locals => {:jobs => @settings.jobs}
      end
    rescue ActiveRecord::ActiveRecordError
      render :update do |page|
        page.replace_html "error-message-job", :inline => "<%= error_messages_for 'job' %>"
        page[:errorExplanation].visual_effect :highlight,
                                              :startcolor => "#ea8c8c",
                                              :endcolor => "#cfe9fa"
        page.delay(4) do
          page[:errorExplanation].remove                            
        end
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
  def add_another_school
    begin
      params[:schools].each_value do |val|
        start_at = Time.local(val[:start_year],val[:start_month],val[:start_day])
        end_at = Time.local(val[:end_year],val[:end_month],val[:end_day])
        val.merge!(:profile_id => current_user.profile.id, :start_at => start_at, :end_at => end_at)
        val.delete_if{|k, v| ["start_year", "start_month", "start_day", "end_year", "end_month", "end_day"].include?(k)}
        @school = School.new(val)
        @school.save!
      end

      @settings.find_school
      render :update do |page|
        page.remove "table-form-school"
        page.insert_html :bottom, "table-form-school-wrapper", "<div id=\"table-form-school\"></div>"
        page.hide "save-button-school"
        page.replace_html "table-schools", :partial => 'new_school', :locals => {:schools => @settings.schools}
      end
    rescue ActiveRecord::ActiveRecordError
      render :update do |page|
        page.replace_html "error-message-school", :inline => "<%= error_messages_for 'school' %>"
        page[:errorExplanation].visual_effect :highlight,
                                              :startcolor => "#ea8c8c",
                                              :endcolor => "#cfe9fa"
        page.delay(4) do
          page[:errorExplanation].remove                             
        end
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
  def add_another_medical
    begin
      params[:medicals].each_value do |val|
        @medical = Medical.new(val.merge(:profile_id => current_user.profile.id))
        @medical.save!
      end

      @settings.find_medical
      render :update do |page|
        page.remove "table-form-medical"
        page.insert_html :bottom, "table-form-medical-wrapper", "<div id=\"table-form-medical\"></div>"
        page.hide "save-button-medical"
        page.replace_html "table-medicals", :partial => 'new_medical', :locals => {:medicals => @settings.medicals}
      end
    rescue ActiveRecord::ActiveRecordError
      render :update do |page|
        page.replace_html "error-message-medical", :inline => "<%= error_messages_for 'medical' %>"
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
  def remove_medical
    begin
      @medical = current_user.profile.medicals.find(params[:id])
      @medical.destroy
    end
    
    respond_to_ajax_remove @medical
  end
  
  # TODO: Move to appropriate controller
  def add_another_medical_condition
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
  def add_another_family
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
    @settings = SettingsPresenter.new(current_user, Facebooker::Session.current, params)
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
      saved = update_personal_info
    end
    return saved
  end

  def load_completed_steps
    @completed_steps = current_user.setup_step
  end

  def load_online
    @settings.load_backup_sources
    @settings.create_fb_login_url(request)
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
           page.replace_html "#{obj.to_str}_#{obj.id}"
         end
       end
     end
   end
end
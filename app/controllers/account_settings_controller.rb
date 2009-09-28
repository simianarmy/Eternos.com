# $Id$

class AccountSettingsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :load_facebook_connect
  before_filter :set_facebook_session
  before_filter :load_completed_steps
  layout 'account_settings'
  
  def index
    find_user_profile
    check_facebook_sync
    clear_timeline_cache
    session[:setup_account] = true
    
    # Dynamic action view based on current setup step
    @content_page = case @completed_steps
    when 1
      load_online
      'online'
    when 2
      load_email_accounts
      'email_account'
    when 3
      load_history
      'your_history'
    else
      'personal_info'
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
    find_user_profile
    respond_to do |format|
      format.js do
        render :update do |page|
          setup_layout_account_setting(page, "account_settings/personal_info")
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
            setup_layout_account_setting(page, "account_settings/personal_info")
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
  
  def load_online
    @online_account = BackupSource.new
    @feed_url = FeedUrl.new
    # What is this sillyness?
    # @recent_backup_sites, @activated_twitter = current_user.backup_sites_names
    backup_sources = current_user.backup_sources
    if backup_sources.any?
      @facebook_account  = backup_sources.by_site(BackupSite::Facebook).first
      @facebook_confirmed = @facebook_account && @facebook_account.confirmed?
      @twitter_accounts = backup_sources.by_site(BackupSite::Twitter).paginate :page => params[:page], :per_page => 10
      @twitter_account   = backup_sources.by_site(BackupSite::Twitter).first
      @twitter_confirmed = @twitter_account && @twitter_account.confirmed?
      @feed_urls = current_user.backup_sources.by_site(BackupSite::Blog).paginate :page => params[:page], :per_page => 10
      @rss_url = backup_sources.by_site(BackupSite::Blog).first
      @rss_confirmed = @rss_url && @rss_url.confirmed?
    end
  end
  
  def online
    load_online
    
    respond_to do |format|
      format.js {
        render :update do |page|
          if params[:page].blank?
            setup_layout_account_setting(page, "online")
          else
            page.replace_html 'result-urls', :partial => 'backup_sources/rss_url_list', 
              :locals => {:feed_urls => @feed_urls}
          end
        end
      }
    end
  end
  
  def email
    load_email_accounts
    @current_gmail = @email_accounts.first
  
    respond_to do |format|
      format.js {
        render :template => 'account_settings/email_account'
      }
    end
  end
  
  def load_history
    find_object_history
  end
  
  def your_history
    load_history
    
    respond_to do |format|
      format.js do
        render :update do |page|
          setup_layout_account_setting(page, "account_settings/your_history")
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

      find_job
      render :update do |page|
        page.remove "table-form-job"
        page.insert_html :bottom, "table-form-job-wrapper", "<div id=\"table-form-job\"></div>"
        page.hide "save-button-job"
        page.replace_html "table-jobs", :partial => 'new_job', :locals => {:jobs => @jobs}
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

      find_school
      render :update do |page|
        page.remove "table-form-school"
        page.insert_html :bottom, "table-form-school-wrapper", "<div id=\"table-form-school\"></div>"
        page.hide "save-button-school"
        page.replace_html "table-schools", :partial => 'new_school', :locals => {:schools => @schools}
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

      find_medical
      render :update do |page|
        page.remove "table-form-medical"
        page.insert_html :bottom, "table-form-medical-wrapper", "<div id=\"table-form-medical\"></div>"
        page.hide "save-button-medical"
        page.replace_html "table-medicals", :partial => 'new_medical', :locals => {:medicals => @medicals}
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

      find_medical_condition
      render :update do |page|
        page.remove "table-form-medical-condition"
        page.insert_html :bottom, "table-form-medical-condition-wrapper", "<div id=\"table-form-medical-condition\"></div>"
        page.hide "save-button-medical-condition"
        page.replace_html "table-medical-conditions", :partial => 'new_medical_condition', :locals => {:medical_conditions => @medical_conditions}
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

      find_family
      render :update do |page|
        page.remove "table-form-family"
        page.insert_html :bottom, "table-form-family-wrapper", "<div id=\"table-form-family\"></div>"
        page.hide "save-button-family"
        page.replace_html "table-families", :partial => 'new_family', :locals => {:families => @families}
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
    begin
      @relationship = current_user.relationships.new(params[:relationship])
      @relationship.end_at = nil if params[:current] == '1'
      
      if @relationship.save
        flash[:notice] = "Relationship saved"
      else
        flash[:error] = @relationship.errors.full_messages.join('<br/>')
      end
    rescue
      flash[:error] = "Unexpected error saving data: " + $!
    end
    
    respond_to do |format|
      format.js
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
          setup_layout_account_setting(page, "account_settings/upgrades")
        end
      end
    end
  end

  # TODO: Move to appropriate controller
  def billings
    respond_to do |format|
      format.js do
        render :update do |page|
          setup_layout_account_setting(page, "account_settings/billings")
        end
      end
    end
  end

  # TODO: Move to appropriate controller
  def save_personal_info
    find_user_profile
    initialize_from_params
    
    respond_to do |format|
      if update_personal_info 
        if has_required_personal_info_fields?
          @current_step = current_user.setup_step
          current_user.completed_setup_step(1)
          flash[:notice] = "Saved"
        else
          flash[:error] = "Please fill in all required fields"
        end
        format.js {
          # On 1st successful save, we want to refresh page to next step
          unless flash[:error] || (@completed_steps > 0)
            render :update do |page|
              page.redirect_to :action => 'index'
            end
          end
        }
      else
        format.js {
          flash[:error] = "Unable to save your changes: <br/>" +
            @errors.join('<br/>')
        }
      end
    end 
  end
  
  # I already did this somewhere else, oh well...
  def select_region
    @regions = Region.find_all_by_country_id(params[:id])
    if @regions
      respond_to do |format|
        format.js do
          render :update do |page|
            page.replace_html "select-region-#{params[:cols_id]}", :partial => 'select_region', :locals => {:regions => @regions, :element => params[:cols_id]}
          end
        end
      end 
    end
  end
  
  #
  # *******   DEVELOPERS: LEAVE THIS METHOD ALONE!!! *******
  #
  def backup_contact_emails
    begin
      # Contacts authenticates in initialization.  If there are any problems logging in, 
      # an exception is raised.
      Contacts::Gmail.new(params[:email][:email], params[:email][:password])

      # At this point authentication has been authorized - create account & add to backup sources
      @current_gmail = GmailAccount.create!(
        :auth_login => params[:email][:email], 
        :auth_password => params[:email][:password], 
        :user_id => current_user.id,
        :backup_site_id => BackupSite.find_by_name(BackupSite::Gmail).id,
        :last_login_at => Time.now)
      @current_gmail.confirmed!
      current_user.completed_setup_step(3)
      @success = true    
      flash[:notice] = "Your email account was successfully saved."
    rescue Exception => message
      flash[:error] = message.to_s
    end
    
    load_email_accounts
    respond_to do |format|
      format.js
    end
  end
  
  private

  # because the views of this controller used in internal IFRAME
  # SO, we have to override login_required method in the parent class
  # The login_required method in parent class doesn't suit in IFRAME.
  def login_required
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      render :partial => "login_required"
    end
  end
  
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
      @user = current_user
      @address_book = @user.address_book
      @profile  = current_user.profile
   end

   def check_facebook_sync
     if @user.always_sync_with_facebook
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
   
   def find_object_history
     find_address
     find_job
     find_school
     find_medical
     find_medical_condition
     find_family
     find_relationship
     @address = Address.new
     @job = Job.new
     @school = School.new
     @medical = Medical.new
     @medical_condition = MedicalCondition.new
     @family = Family.new
     @relationship = Relationship.new
   end
   
   def find_address
     @address_book = current_user.address_book
     @addresses = @address_book.addresses
   end
   
   def find_job
     @jobs = current_user.profile.careers
   end
   
   def find_school
     @schools = current_user.profile.schools
   end
   
   def find_medical
     @medicals = current_user.profile.medicals
   end
   
   def find_medical_condition
     @medical_conditions = current_user.profile.medical_conditions
   end
   
   def find_family
     @families = current_user.profile.families
   end
   
   def find_relationship
     @relationships = Relationship.find_all_by_user_id(current_user.id)
   end
   
   def load_email_accounts
     @email_accounts = current_user.backup_sources.by_site(BackupSite::Gmail).paginate :page => params[:page], :per_page => 10
   end
   
   def load_completed_steps
     @completed_steps = current_user.setup_step
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
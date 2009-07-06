# $Id$

class AccountSettingsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :load_facebook_connect
  before_filter :set_facebook_session
  layout 'account_setup'
  
  def set_feed_url
    @feed = FeedUrl.find(params[:id])
    @feed.url = params[:value]
    if @feed.save
      render :text => @feed.send(:url).to_s
    else
      render :text => "Invalid RSS feed URL"
    end
  end
  
  def set_contact_name
    @contact = ContactEmail.find(params[:id])
    @contact.name = params[:value]
    if @contact.save
      render :text => @contact.send(:name).to_s
    else
      render :text => params[:value]
    end
  end
  
  def set_contact_email
    @contact = ContactEmail.find(params[:id])
    @contact.email = params[:value]
    if @contact.save
      render :text => @contact.send(:email).to_s
    else
      render :text => params[:value]
    end
  end
  
  def index
    find_user_profile
    check_facebook_sync
    
    respond_to do |format|
      format.js 
      format.html 
    end
  end

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
          setup_layout_account_setting(page, "step1", "account_settings/personal_info")
        end
      end
    end
  end

  def facebook_sync
    find_user_profile
    saved = merge_with_facebook
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
    @feed_urls = current_user.backup_sources.by_site(BackupSite::Blog).paginate :page => params[:page], :per_page => 10
    if params[:method].blank?
      @online_account = BackupSource.new
      @feed_url = FeedUrl.new
      @recent_backup_sites, @activated_twitter = current_user.backup_sites_names
      
      respond_to do |format|
        format.js do
          render :update do |page|
            if params[:page].blank?
              setup_layout_account_setting(page, "step2", "account_settings/online")
            end
            page.replace_html 'result-urls', :partial => 'shared/url_list'
          end
        end
      end
    else
      if f = current_user.backup_sources.find(params[:id].to_i)
        f.destroy
      end
      render :update do |page|
        page.remove "url-list-#{params[:id]}"
      end
    end
  end
  
  def email_account
    @contact_emails = current_user.profile.contact_emails.paginate :page => params[:page], :per_page => 10
    if params[:method].blank?
      respond_to do |format|
        format.js do
          render :update do |page|
            if params[:page].blank?
              setup_layout_account_setting(page, "step3", "account_settings/email_account")
            end
            page.replace_html 'result-email-contacts', :partial => 'shared/email_account_list'
          end
        end
      end
    else
      @contact_email = ContactEmail.find(params[:id])
      @contact_email.destroy

      render :update do |page|
        page.remove "contact-list-#{@contact_email.id}"
      end
    end
  end

  def your_history
    find_object_history
    respond_to do |format|
      format.js do
        render :update do |page|
          setup_layout_account_setting(page, "step4", "account_settings/your_history")
        end
      end
    end  
  end
  
  def add_another_address
    begin
      params[:addresses].each_value do |val|
        start_at = Time.local(val[:year_in],val[:month_in],val[:day_in])
        end_at = Time.local(val[:year_out],val[:month_out],val[:day_out])
        val.merge!(:user_id => current_user.id, :moved_in_on => start_at, :moved_out_on => end_at)
        val.delete_if{|k, v| ["year_in", "month_in", "day_in", "year_out", "month_out", "day_out"].include?(k)}
        @address = Address.new(val)
        @address.addressable = current_user.profile
        @address.save!
      end
      
      find_address
      render :update do |page|
        page.remove "table-form-address"
        page.insert_html :bottom, "table-form-address-wrapper", "<div id=\"table-form-address\"></div>"
        page.hide "save-button-address"
        page.replace_html "table-addresses", :partial => 'new_address', :locals => {:addresses => @addresses}
      end
    rescue ActiveRecord::ActiveRecordError
      render :update do |page|
        page.replace_html "error-message-address", :inline => "<%= error_messages_for 'address' %>"
        page[:errorExplanation].visual_effect :highlight,
                                              :startcolor => "#ea8c8c",
                                              :endcolor => "#cfe9fa"
        page.delay(4) do
          page[:errorExplanation].remove                        
        end
      end
    end
  end
  
  def remove_address
    @address = Address.find(params[:id])
    @address.destroy
    
    find_address
    respond_to do |format|
      format.js do
        render :update do |page|
        page.replace_html "table-addresses", :partial => 'new_address', :locals => {:addresses => @addresses}
        end
      end
    end
  end

  def add_another_job
    begin
      params[:jobs].each_value do |val|
        start_at = Time.local(val[:start_year],val[:start_month],val[:start_day])
        end_at = Time.local(val[:end_year],val[:end_month],val[:end_day])
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
  
  def remove_job
    @job = Job.find(params[:id])
    @job.destroy
    
    find_job
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "table-jobs", :partial => 'new_job', :locals => {:jobs => @jobs}
        end
      end
    end 
  end
  
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
  
  def remove_school
    @school = School.find(params[:id])
    @school.destroy
    
    find_school
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "table-schools", :partial => 'new_school', :locals => {:schools => @schools}
        end
      end
    end 
  end
  
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
  
  def remove_medical
    @medical = Medical.find(params[:id])
    @medical.destroy
    
    find_medical
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "table-medicals", :partial => 'new_medical', :locals => {:medicals => @medicals}
        end
      end
    end 
  end
  
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
  
  def remove_medical_condition
    @medical_condition = MedicalCondition.find(params[:id])
    @medical_condition.destroy
    
    find_medical_condition
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "table-medical-conditions", :partial => 'new_medical_condition', :locals => {:medical_conditions => @medical_conditions}
        end
      end
    end 
  end
  
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
  
  def remove_family
    @family = Family.find(params[:id])
    @family.destroy
    
    find_family
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "table-families", :partial => 'new_family', :locals => {:families => @families}
        end
      end
    end 
  end
  
  def add_another_relationship
    begin
      params[:relationships].each_value do |val|
        start_at = Time.local(val[:start_year],val[:start_month],val[:start_day])
        end_at = Time.local(val[:end_year],val[:end_month],val[:end_day])
        val.merge!(:user_id => current_user.id, :start_at => start_at, :end_at => end_at)
        val.delete_if{|k, v| ["start_year", "start_month", "start_day", "end_year", "end_month", "end_day"].include?(k)}
        @relationship = Relationship.new(val)
        @relationship.save!
      end

      find_relationship
      render :update do |page|
        page.remove "table-form-relationship"
        page.insert_html :bottom, "table-form-relationship-wrapper", "<div id=\"table-form-relationship\"></div>"
        page.hide "save-button-relationship"
        page.replace_html "table-relationships", :partial => 'new_relationship', :locals => {:relationships => @relationships}
      end
    rescue ActiveRecord::ActiveRecordError
      render :update do |page|
        page.replace_html "error-message-relationship", :inline => "<%= error_messages_for 'relationship' %>"
        page[:errorExplanation].visual_effect :highlight,
                                              :startcolor => "#ea8c8c",
                                              :endcolor => "#cfe9fa"
        page.delay(4) do
          page[:errorExplanation].remove                             
        end
      end   
    end
  end
  
  def remove_relationship
    @relationship = Relationship.find(params[:id])
    @relationship.destroy
    
    find_relationship
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "table-relationships", :partial => 'new_relationship', :locals => {:relationships => @relationships}
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
  
  def backup_contact_emails
    gmail = Contacts::Gmail.new(params[:gmail][:username], params[:gmail][:password])
    gmail.contacts.each do |n, e|
      ContactEmail.create({:profile_id => current_user.profile.id, :name => n, :email => e})
    end
    @contact_emails = current_user.profile.contact_emails.paginate :page => params[:page], :per_page => 10
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "flash-message", :text => "Your contact emails was successfully saved."
          page.replace_html 'result-email-contacts', :partial => 'shared/email_account_list'
        end
      end
    end
  rescue Contacts::AuthenticationError => message
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "flash-message", :text => message.to_s
        end
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

   def check_facebook_sync
     if @user.always_sync_with_facebook
       @checked_always_sync = true
       merge_with_facebook
     end
   end

   def merge_with_facebook
     saved = false
     if facebook_session && (fb_user = facebook_session.user)
       if fb_user.populate(*Facebooker::User::FIELDS)
          facebook_profile = {}
          Facebooker::User::FIELDS.each {|f| facebook_profile[f] = fb_user.send(f)}
          @new_address_book, @new_profile = FacebookProfile.convert_fb_profile_to_sync_with_local_setup(facebook_profile)
          saved = update_personal_info
        end
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
     @addresses = current_user.profile.addresses
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

end
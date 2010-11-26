# $Id$

class AccountSettingsController < MemberHomeController
  before_filter :login_required
  require_role "Member"
  before_filter :set_facebook_connect_session
  before_filter :load_presenter
  before_filter :load_completed_steps
  layout 'account_settings'
  
  ssl_required :all # Way nicer than specifying each frickin action
  #ssl_allowed :all # It must be so for Lightview to access parent window :(
  
  def index
    check_account_facebook_sync
    clear_timeline_cache
    session[:setup_account] = true
    
    Rails.logger.debug "setup: completed steps = #{@completed_steps}"
    # Dynamic action view based on current setup step
    session[:account_settings_page] = @content_page = case @completed_steps
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
    session[:account_settings_page] = @content_page = 'personal_info'
    
    respond_to do |format|
      format.js do
        render :update do |page|
          update_account_settings_layout(page, "personal_info", @settings)
        end
      end
    end
  end
  
  def your_history
    @settings.load_history
    session[:account_settings_page] = @content_page = 'your_history'
    
    respond_to do |format|
      format.js do
        render :update do |page|
          update_account_settings_layout(page, "your_history", @settings)
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

  def facebook_sync
    if @synched = merge_with_facebook
      flash[:notice] = "Synched with Facebook Successfully"
    else
      flash[:error] = "#{flash[:error]}  Please try again or notify support."
    end
    # Required for rjs to know whether or not to redirect 
    @content_page = session[:account_settings_page]
    respond_to do |format|
      format.html {
        redirect_to account_settings_url
      }
      format.js
    end
  end
  
  def always_sync_with_facebook
    @synched = params[:facebook_sync]
    current_user.update_attribute(:always_sync_with_facebook, @synched)
    if @synched
      if merge_with_facebook
        flash[:notice] = "Synched with Facebook Successfully"
      else
        flash[:error] = "Error Synching with Facebook!  Please try again or notify support."
      end
    end

    # Required for rjs to know whether or not to redirect 
    @content_page = session[:account_settings_page]
    respond_to do |format|
      format.js
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
    
    respond_to do |format|
      if @job.save
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
    
    respond_to do |format|
      if @school.save
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
    
    respond_to do |format|
      if @medical.save
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
    @medical_condition = current_user.profile.medical_conditions.new(params[:medical_condition])
    
    respond_to do |format|
      if @medical_condition.save
        flash[:notice] = "Medical Condition added"
        format.html
        format.js
      else
        format.js {
          flash[:error] = @medical_condition.errors.full_messages.join('<br/>')
        }
        format.html
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
    @family = current_user.profile.families.new(params[:family])
    if saved = @family.save
      flash[:notice] = "Family Member added"
    end
    
    respond_to do |format|
      format.html {
        redirect_to account_settings_path if saved
      }
      format.js {
        flash[:error] = @family.errors.full_messages.join('<br/>') unless saved
        
        # For Ajax file upload support
        responds_to_parent do 
          render :action => 'new_family'
        end
      }
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
    @relationship = current_user.profile.relationships.new(params[:relationship])
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
      format.html {
        redirect_to account_settings_path
      }
      format.js {
        # For Ajax file upload support
        responds_to_parent do 
          render :action => 'new_relationship'
        end
      }
    end
  end
  
  # TODO: Move to appropriate controller
  def remove_relationship
    begin
      @relationship = current_user.profile.relationships.find(params[:id])
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

  def check_account_facebook_sync
    if @always_sync_account_info_with_facebook = current_user.always_sync_with_facebook
      merge_with_facebook
    end
  end

  def merge_with_facebook
    if facebook_session && (fb_user = facebook_session.user)
      current_user.link_fb_connect(fb_user.id) if current_user.facebook_id.nil?
      begin
        current_user.sync_with_facebook_profile(fb_user)
      rescue Exception => e
        flash[:error] = "Unable to sync with Facebook profile! #{e.message}"
        false
      end
    else
      flash[:error] = "Unable to confirm your Facebook account"
    end
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
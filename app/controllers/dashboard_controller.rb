class DashboardController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :set_facebook_connect_session
  before_filter :load_member_home_presenter
  layout 'member'
  
  ssl_required :all # Way nicer than specifying each frickin action
  
  def show
    @dashboard = DashboardPresenter.new(current_user)
    @backup_data = @dashboard.backup_data_counts
    @email_lists = Hash.new(false)
    current_user.email_lists.each do |el|
      @email_lists[el.name.to_sym] = el.is_enabled
    end
  end

  def edit_profile
    @personal_settings = ProfilePresenter.new(current_user, Facebooker::Session.current, params)
    @personal_settings.load_personal_info
  end

  # This action functionality copied from AccountSettingsController 
  def save_personal_info
    @personal_settings = ProfilePresenter.new(current_user, Facebooker::Session.current, params)
    if @personal_settings.save(params)
      if @personal_settings.has_required_personal_info_fields?
        flash[:notice] = "Personal Info Saved"
      else
        flash[:error] = "Please fill in all required fields"
      end
    else
      flash[:error] = "Unable to save your changes: <br/>" + @personal_settings.errors.full_messages.to_s
    end
    
    respond_to do |format|
      format.js
    end
  end    
      
  def regions
    @regions = params['c_id'].empty? ? [] : Region.find(:all,
                           :conditions => {:country_id => params['c_id']},
                           :order => :name).map{|reg| {:name => reg.name, :id => reg.id}}
    @regions.unshift({:name => params['c_id'].empty? ? '&lt;Select country&gt;' : '&lt;Select region&gt;', :id => nil})
    @curr_reg = @regions.select {|reg| reg[:id].to_s == params[:curr]}.first
    @curr_reg = @curr_reg[:id] if @curr_reg
    respond_to do |format|
      format.html {render :layout => false}
    end
  end
end

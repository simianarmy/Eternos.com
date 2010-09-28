class DashboardController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :set_facebook_connect_session
  before_filter :load_member_home_presenter
  layout 'member'
  
  ssl_required :all # Way nicer than specifying each frickin action
  
  def show
    @user = current_user
    @days_signed = (Date.current - @user.created_at.to_date + 1).to_i.to_s
    @backup_data = {:size => 0, :photos => 0, :videos => 0, :emails => 0, 
      :tweets => 0, :fb => 0, :rss => 0, :total => 0}

    @backup_data[:albums] = @user.photo_albums.size
    @backup_data[:photos] = @user.contents.photos.count
    @backup_data[:videos] = @user.contents.all_video.count
    @backup_data[:audio] = @user.contents.all_audio.count
    @backup_data[:tweets] = @user.activity_stream.items.twitter.count
    @backup_data[:fb] = @user.activity_stream.items.facebook.count
    @backup_data[:rss] = FeedEntry.belonging_to_user(@user.id).count
    @backup_data[:emails] = BackupEmail.belonging_to_user(@user.id).count
    @backup_data[:total] = @backup_data.values.sum
    
    @backup_sources = @user.backup_sources.size
    @active_backup_sources = @user.backup_sources.active.size
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

class DevStagingMapsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :load_map, :except => [:new, :create]
  layout nil
  
  def index
    if @dev_staging_map
      render :action => :show
    else
      redirect_to :action => :new
    end
  end
  
  def show
  end
  
  def new
    create_map
  end
  
  def create
    @dev_staging_map = create_map
    @dev_staging_map.update_attributes(params[:dev_staging_map])
    if @dev_staging_map.save
      flash[:notice] = "Successfully created devstagingmap."
      redirect_to @dev_staging_map
    else
      render :action => 'new'
    end
  end
  
  def edit
    
  end
  
  def update
    if @dev_staging_map.update_attributes(params[:dev_staging_map])
      flash[:notice] = "Successfully updated devstagingmap."
      redirect_to @dev_staging_map
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @dev_staging_map.destroy
    flash[:notice] = "Successfully destroyed devstagingmap."
    redirect_to dev_staging_maps_url
  end
  
  private
  
  def create_map
    @dev_staging_map = DevStagingMap.new
    if ENV['RAILS_ENV'] == 'development'
      @dev_staging_map.dev_user_id = current_user.id
    else
      @dev_staging_map.staging_user_id = current_user.id
    end
    @dev_staging_map
  end
  
  def load_map
    @dev_staging_map = if ENV['RAILS_ENV'] == 'development'
      DevStagingMap.find_by_dev_user_id(current_user.id)
    else
      DevStagingMap.find_by_staging_user_id(current_user.id)
    end
  end
end

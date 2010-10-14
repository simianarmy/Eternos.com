class BackupErrorCodesController < AdminController
  
  
  def index
    @backup_error_codes = BackupErrorCode.find(:all)
  end
  
  def show
    @backup_error_code = BackupErrorCode.find(params[:id])
  end
  
  def new
    @backup_error_code = BackupErrorCode.new
  end
  
  def create
    @backup_error_code = BackupErrorCode.new(params[:backup_error_code])
    if @backup_error_code.save
      flash[:notice] = "Successfully created backuperrorcode."
      redirect_to @backup_error_code
    else
      render :action => 'new'
    end
  end
  
  def edit
    @backup_error_code = BackupErrorCode.find(params[:id])
  end
  
  def update
    @backup_error_code = BackupErrorCode.find(params[:id])
    if @backup_error_code.update_attributes(params[:backup_error_code])
      flash[:notice] = "Successfully updated backuperrorcode."
      redirect_to @backup_error_code
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @backup_error_code = BackupErrorCode.find(params[:id])
    @backup_error_code.destroy
    flash[:notice] = "Successfully destroyed backuperrorcode."
    redirect_to backup_error_codes_url
  end
end

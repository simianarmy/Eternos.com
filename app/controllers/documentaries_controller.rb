class DocumentariesController < StoriesController
  include TagsAutoComplete
  
  def new
    @documentary = current_user.documentaries.new
    build_recording
  end
  
  def show
    @story = @documentary = current_user.documentaries.find(params[:id])
    @recording = @documentary.attached_recording
  end
  
  def create
    @documentary = current_user.documentaries.new(params[:documentary])
    
    if @documentary.save
      flash[:notice] = "Successfully created!"
      session[:last_recording] = nil
      redirect_to @documentary
    else
      build_recording if params[:documentary][:recording_id]
      render :action => 'new'
    end
  end
  
  def update
    @documentary = current_user.documentaries.find(params[:id])
    respond_to do |format|
      if @documentary.update_attributes(params[:documentary])
        format.html { 
          flash[:notice] = "Successfully updated."
          redirect_to @documentary 
        }
      else
        format.html
      end
    end
  end
    
  # Called by Flash recorder app when SAVE action is successful (after 
  # create action has completed successfully)
  # New recording's record ID is saved in a session variable
  def post_recording
    begin
      @recording = Recording.find session[:last_recording]
      @story = @documentary = current_user.documentaries.av_attachment_recording_id_eq(@recording.id).first
    rescue
      flash[:error] = "Unexpected error saving your recording!"
    end
  end
  
  private
  
  def build_recording
    # Destroy last recording & associated content object if redoing
    if params[:redo]
      Recording.destroy(session[:last_recording]) rescue nil
      session[:last_recording] = nil
    end
    if session[:last_recording] 
      @recording = Recording.find(session[:last_recording]) rescue nil
    end
    @recording ||= Recording.new
  end
    
end

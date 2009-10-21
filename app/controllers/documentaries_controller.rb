class DocumentariesController < StoriesController
  include TagsAutoComplete
  
  def new
    @documentary = current_user.documentaries.new
    build_recording
  end
  
  def show
    @story = @documentary = current_user.documentaries.find(params[:id])
    @recording = @documentary.recording
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

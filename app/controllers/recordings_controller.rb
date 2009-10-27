class RecordingsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  session :cookie_only => false, :only => :create
  
  def index
    @contents = current_user.contents.find_all_recordings
  end
  
  def new
    @parent = params[:attach_to]
    if params[:layout]
      render :layout => params[:layout]
    end
  end
  
  def create
    # Add file extension to filename parameter - flash recorder omits it
    if params[:filename] and (params[:filename] !~ /\.\w+$/)
      params[:filename] += ".flv"
    end
    @recording = Recording.new(:member => current_user, :filename => params[:filename])
    
    respond_to do |format|
      if @recording.save
        # Save recording id to session for new object
        session[recording_session_key.to_sym] = session[:last_recording] = @recording.id
        
        # start transcoding process
        @recording.analyze
        
        # Return status code only to flash app
        # On success, will redirect to redirecturl value in config xml
        format.html { 
          flash[:notice] = "Recording saved."
          render :nothing => true, :status => 200
        }
      else
        format.html {
          flash[:error] = @recording.errors.full_messages.to_s
          RAILS_DEFAULT_LOGGER.debug "Error saving recording: " + flash[:error]
          render :nothing => true, :status => 500
        }
      end
    end
  end
  
  def show
    @recording = current_user.recordings.find(params[:id]) rescue nil
    
    respond_to do |format|
      format.html
      format.xml { render :layout => false, :action => 'flashrecorder' }
    end
  end
    
  def destroy
   @recording = current_user.recordings.find(params[:id])
   if @recording
     @recording.destroy
     # Destroy associated session key so that build_recording doesn't look for it
     session["#{params[:parent]}_last_recording".to_sym] = nil
   end
    
    respond_to do |format|
      format.html {
        flash[:notice] = "Recording deleted"
      }
      format.js {
        render :nothing => true, :status => 200
      }
    end
  end
  
  # Performs redirect to recorder flash app after saving associated object id in session
  def redir_to_app
    session[:parent_id] = params[:parent_id]
    redirect_to "/swf/Recorder.swf?userid=#{current_user.id}"
  end
  
  # Required to render recorder config xml
  def flashrecorder
    @parent = if params[:anywhere]
      params[:anywhere].singularize
    else
      'recording'
    end
    @redirect_on_save_url = if params[:anywhere]
      url_for(:controller => params[:anywhere], :action => :new, :recording => 1)
    else
      recordings_path
    end
    RAILS_DEFAULT_LOGGER.debug "recorder redirect on save to #{@redirect_on_save_url}"
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end

  private
  
  def recording_session_key
    params[:recording_id_session_key] || :last_recording
  end
end

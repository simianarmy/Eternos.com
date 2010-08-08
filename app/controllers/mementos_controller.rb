# $Id$

class MementosController < MemberHomeController
  layout 'mementos', :only => 'new'
  
  #skip_before_filter :load_member_home_presenter
  
  def new  
    @memento = current_user.mementos.new
    @mementos = current_user.mementos.descend_by_created_at
    @max_listed = 15
  end
  
  def create
    @memento = current_user.mementos.new(params[:memento])
    
    if params[:slide]
      @memento.slides = params[:slide]
    end
    
    @memento.save
    
    respond_to do |format|
      format.js {
        if @memento.errors
          flash[:errors] = "Sorry, we were unable to create your Memento.  Please try again."
        else
          flash[:notice] = "Memento saved!"
        end
      }
    end
  end
  
  def edit
    @memento = current_user.mementos.find(params[:id])
  end
  
  def new_content
    @object = @content = current_user.contents.new
    
    respond_to do |format|
      format.html {
        render :layout => 'dialog'
      }
    end
  end
  
  protected
  
  def load_artifacts
    contents = current_user.contents
    @albums = contents.photo_albums
    @videos = contents.web_videos
    @audio  = contents.audio
    @music  = contents.music
  end
  
end

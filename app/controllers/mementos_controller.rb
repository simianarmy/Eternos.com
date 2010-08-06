# $Id$

class MementosController < MemberHomeController
  layout 'mementos', :only => 'new'
  
  #skip_before_filter :load_member_home_presenter
  
  def new  
    @memento = current_user.mementos.new
  end
  
  def create
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

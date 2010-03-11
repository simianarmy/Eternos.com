# $Id$

class MementosController < MemberHomeController
  layout 'member_standalone'
  
  def new
    
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

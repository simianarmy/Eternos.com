# $Id$

class MementosController < ApplicationController
  before_filter :login_required
  require_role ['Member']
  
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

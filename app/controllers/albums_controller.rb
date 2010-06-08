# $Id$
#
# Just like the BackupPhotoAlbumsController

class AlbumsController < ApplicationController
  before_filter :login_required
  require_role "Member"

  def show
    @album = Album.user_id_eq(current_user.id).find(params[:id])
    @photos = @album.photos
    
    respond_to do |format|
      format.html {
        case params[:view]
        when 'memento_editor'
          @contents = @photos
          # content list view for memento editor
          render 'mementos/photo_grid'
        else
          render :action => :show
        end
      }
    end
  end
end

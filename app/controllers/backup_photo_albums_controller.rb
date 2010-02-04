class BackupPhotoAlbumsController < ApplicationController
  before_filter :login_required
  require_role "Member"

  def show
    @album = BackupPhotoAlbum.by_user(current_user.id).find(params[:id])
    @photos = @album.content_photos
    
    respond_to do |format|
      format.html {
        case params[:view]
        when 'memento_editor'
          @contents = @photos
          # content list view for memento editor
          render 'mementos/artifact_picker'
        else
          render :action => :show
        end
      }
    end
  end
end

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
    if params[:audio]
      @memento.soundtrack = params[:audio]
    end
    @memento.save

    
    respond_to do |format|
      format.js {
        if @memento.errors
          flash[:error] = @memento.errors.full_messages.join('<br/>')
        else
          flash[:notice] = "Memento saved!"
        end
      }
    end
  end
  
  # Load memento from db into editor
  def edit
    # Convert to js-compatible data structure
    begin
      @memento = current_user.mementos.find(params[:id])
      @slides = []
      @sounds = []
      (@memento.slides || []).each do |s|
        # Convert cgi format: param = [value] to hash
        slide = CGI.parse(s).inject({}) {|h, (k, v)| h[k] = v.first; h }
      
        # Load slide content object data if any
        Rails.logger.debug "Parsed params: #{slide.inspect}"
        if cid = slide['cid']
          if c = current_user.contents.find(cid)
            Rails.logger.debug "Found content object: #{c.id}"
            slide.merge!({:url => c.player_url, :thumb_url => c.thumbnail_url})
          end
        end
        @slides << slide
      end
      Rails.logger.debug "Slides: #{@slides.inspect}"
    
      # Load soundtrack data
      (@memento.soundtrack || []).each do |s|
        sound = CGI.parse(s).inject({}) {|h, (k, v)| h[k] = v.first; h }
        @sounds << sound
      end
      Rails.logger.debug "Audio: #{@sounds.inspect}"
    rescue
      flash[:error] = @error = "Sorry, we were not able to load this Memento!"
    end
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

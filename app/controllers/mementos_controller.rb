# $Id$

class MementosController < MemberHomeController
  layout 'mementos', :only => ['new', 'index']
  
  before_filter :login_required, :except => [:show]
  before_filter :check_roles, :except => [:show]
  before_filter :set_facebook_connect_session, :except => [:show, :new_content]
  before_filter :load_member_home_presenter, :except => [:show, :new_content]
  before_filter :set_constants
  
  def new  
    @memento = current_user.mementos.new
    @mementos = current_user.mementos.descend_by_created_at
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
  
  def index
    @memento = current_user.mementos.new
    @mementos = current_user.mementos.descend_by_created_at
    @max_listed = @mementos.size # Don't display 'previous' list in layout
    
    render :action => 'new'
  end
  
  # Public view of memento movie - load it & play!
  def show
    if @memento = Memento.find_by_uuid(params[:id])
      create_memento_json
    end
    
    respond_to do |format|
      format.html {
        unless @memento
          render_404 && return 
        end
      }
    end
  end
  
  # Load memento from db into editor
  def edit
    @memento = current_user.mementos.find(params[:id])
    
    create_memento_json
  end
  
  # Save changes to existing memento
  def update
    if params[:memento][:id]
      begin
        @memento = Memento.find_by_uuid(params[:memento][:id])
        @memento.update_attributes!(params[:memento])
        
        @memento.slides = params[:slide]
        @memento.soundtrack = params[:audio]
        
        @memento.save
      rescue
        @errors = $!
      end
    end

    respond_to do |format|
      format.js {
        if @memento && @memento.errors.any?
          flash[:error] = @errors = @memento.errors.full_messages.join('<br/>')
        elsif @errors
          flash[:error] = @errors
        else
          flash[:notice] = "Memento saved!"
        end
        Rails.logger.debug "Flash values = #{flash.inspect}"
      }
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
  
  def set_constants
    @max_listed = 10
    @max_caption_length = 165
  end
  
  # Convert to js-compatible data structure
  def create_memento_json
    begin
      @slides = []
      @sounds = []
      (@memento.slides || []).each do |s|
        # Convert cgi format: param = [value] to hash
        slide = CGI.parse(s).inject({}) {|h, (k, v)| h[k] = v.first; h }
      
        # Load slide content object data if any
        Rails.logger.debug "Parsed params: #{slide.inspect}"
        if cid = slide['cid']
          if c = Content.find(cid)
            Rails.logger.debug "Found content object: #{c.id}"
            slide.merge!({:url => c.player_url, :thumb_url => c.thumbnail_url||c.content_icon})
          end
        end
        @slides << slide
      end
      Rails.logger.debug "Slides: #{@slides.inspect}"
    
      # Load soundtrack data
      (@memento.soundtrack || []).each do |s|
        sound = CGI.parse(s).inject({}) {|h, (k, v)| h[k] = v.first; h }
        
        # Load audio content object data if any
        Rails.logger.debug "Parsed params: #{sound.inspect}"
        if cid = sound['cid']
          if c = Content.find(cid)
            Rails.logger.debug "Found content object: #{c.id}"
            sound.merge!({:url => c.player_url, :thumb_url => c.thumbnail_url||c.content_icon, 
              :duration => c.duration_seconds})
          end
        end
        
        @sounds << sound
      end
      Rails.logger.debug "Audio: #{@sounds.inspect}"
    rescue Exception => e
      Rails.logger.error "Exception in create_memento_json! #{e.class} #{e.message}"
      flash[:error] = @error = "Sorry, we were not able to load this Memento!"
    end
  end
end

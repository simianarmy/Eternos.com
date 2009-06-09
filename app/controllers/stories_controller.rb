# $Id$
class StoriesController < ApplicationController
  before_filter :login_required
  before_filter :load_artifacts, :except => [:index, :destroy]
 
  require_role "Member"
  
  include CommonSettings
  include TagsAutoComplete
  
  def index
    @stories = current_user.stories.search_text(params[:search])
  end
  
  def show
    @story = current_user.stories.find(params[:id])
    @recording = @story.attached_recording || current_user.recordings.new
    
    respond_to do |format|
      format.html
      format.js {
        @quick_view = true
        render :action => :show, :layout => false
      }
    end
  end
  
  def new
    @story = current_user.stories.new
    @story.story = I18n.t('messages.new.message')
    build_recording(:story_last_recording)
  end
  
  def begin_story
  end
  
  def create
    @story = current_user.stories.new(params[:story])
    @story.recording_id = session[:story_last_recording] if session[:story_last_recording]
    
    if @story.save
      flash[:notice] = "Successfully created story."
      session[:story_last_recording] = nil
      redirect_to @story
    else
      build_recording(:story_last_recording) if session[:story_last_recording]
      render :action => 'new'
    end
  end
  
  def update
    @story = current_user.stories.find(params[:id])
    
    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { 
          flash[:notice] = "Successfully updated story."
          redirect_to story_path(@story) 
        }
        format.xml { head :ok }
        format.js { 
          # TODO: MOVE TO RJS!
          
          # Photos are submitted using hidden iframe + ajax trick - respond_to_parent
          # plugin used to update iframe container page.
          if params[:story][:photo]
            responds_to_parent do 
              render :update do |page|
                page.replace_html :thumb_and_toggle_link, :partial => 'photo_thumb', 
                  :locals => {:story => @story}
                page.toggle :photo_file_form
                page.form.reset "edit_story_#{@story.id}"
                page << "Event.addBehavior.reload();" # Lowpro needs reboot after ajax
              end
            end
          else
            load_settings_view_objects(@story, params)
          end
        }
      else
        format.html { render :action => "show" }
        format.xml { render :xml => @story.errors,
          :status => :unprocessable_entity
        }
        format.js {
          # simple textfield updates call helper, otherwise use update rjs
          flash[:error] = @story.errors.full_messages
          @story.reload
          if params[:category_update]
            @category = @story.category 
          elsif params[:time_period_update]
            @time_period = @story.time_period
          end
        }
      end
    end
  end
  
  def destroy
    @story = current_user.stories.find(params[:id])
    @story.destroy
    flash[:notice] = "Successfully destroyed story."
    respond_to do |format|
      format.html
      format.js {
        # TODO: MOVE TO RJS!
        render :update do |page|
          page.flash_and_fade
          page.replace_html dom_id(@story), ''
        end
      }
    end
  end
  
  private
  
end

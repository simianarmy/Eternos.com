# $Id$

# DON'T INHERIT FROM MemberHomeController!  UPLOADER NEEDS SPECIFIC before_filters ENABLED
class ContentsController < ApplicationController  
  include TagsAutoComplete
  include DecorationsHelper
  
  before_filter :login_required
  require_role "Member"
  before_filter :load_member_home_presenter, :except => [:create]
  #skip_before_filter :verify_authenticity_token, :only => [:create]

  layout 'member_page', :only => [:new, :create, :edit_selection]
  
  def index
    @content_type = params[:type]
    key = Digest::MD5.hexdigest("content:#{current_user.id}:#{@content_type}")
    @contents = Rails.cache.fetch(key, :expires_in => 10.minutes) {
      case @content_type
      when 'albums'
        current_user.contents.photo_albums.map(&:collection)
      when 'web_videos'
        current_user.contents.web_videos
      when 'audio'
        current_user.contents.audio
      when 'music'
        current_user.contents.music
      when 'all_audio'
        current_user.contents.all_audio
      else
        current_user.contents
      end
    }
    respond_to do |format|
      format.html {
        case params[:view]
        when 'memento_editor'
          # content list view for memento editor
          render 'mementos/artifact_picker'
        else
          render :action => :index
        end
      }
    end
  end
  
  def gallery
    @parent = if params[:ref_type]
      params[:ref_type].constantize.find(params[:ref_id])
    end
    @contents = current_user.contents.search_text(params[:search])
  end
  
  def show
    begin
      @content = current_user.contents.find(params[:id])
    rescue
      @content = nil
      Rails.logger.error "Error looking up contents by ID: #{params[:id]}"
    end
    
    respond_to do |format|
      format.html
      format.js { 
        if @content
          render :action => :show, :layout => nil 
        else
          render :nothing => true, :status => :ok
        end
      }
    end
  end
  
  def new
    @content = current_user.contents.new
    
    # Sometimes content uploads area for specific containers, ie: story elements.
    # Setup view instance vars for form create url
    if params[:ref_type]
      el = params[:ref_type].constantize.find(params[:ref_id])
      @form_url = help.build_decoration_path(el)
      @object = :decoration
    else
      @object = @content
    end
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @content = Content.factory(params[:content])
    @content.owner = current_user
    
    session[:refresh_images] = true
    respond_to do |format|
      # Must use 'any' for compatibility with IE text/* accept headers
      format.any {
        if params[:Filename]
          result = AjaxFileUpload.save(@content)
          render :json => result.to_json
        elsif @content.save
          flash_redirect "File succesfully uploaded", contents_path
        else
          flash[:error] = "Error uploading file!"
          render :action => :new
        end
      }
    end
  end
  
  def edit
    @content = current_user.contents.find(params[:id])
  end
  
  def edit_selection
    @contents = if ignore_nil { params[:content][:ids] }
      current_user.contents.find_all_by_id(params[:content][:ids].split(','))
    else
      []
    end
    flash[:error] = "Could not find media matching your selection" if @contents.empty?
  end
  
  def update
    @content = current_user.contents.find(params[:id])
    
    respond_to do |format|
      if @content.update_attributes(params[:content])
        session[:refresh_images] = true
        flash[:notice] = "Updated!"
        format.html {       
          redirect_to content_path(@content) 
        }
        format.xml { head :ok }
        format.js {
          # Required for STI children to use this method
          render :template => 'contents/update'
        }
      else
        format.html { render :action => "show" }
        format.xml { render :xml => @content.errors,
          :status => :unprocessable_entity
        }
        format.js {
          flash[:error] = @content.errors.full_messages
          @content.reload
          # Required for STI children to use this method
          render :template => 'contents/update'
        }
      end
    end
  end
  
  def update_selection
    if params[:content] and !params[:content].empty?
      # TODO: Fix form hint parsing - this is too complicated!
      #global_tags = params[:tag_list] ? filter_hint_form_value('tags', params[:tag_list]) : ""
      global_tags = params[:tag_list] || ""
      auth_settings = params[:content].delete(:privacy_settings)
      
      params[:content].each_pair do |content_id, attributes|
        if content = current_user.contents.find_by_id(content_id)
          # Add global tags to content tags
          # TODO: Fix form hint parsing - this is too complicated!
          #content_tags = filter_hint_form_value('tags', attributes.delete(:tag_list)) || ""
          if content_tags = attributes[:tag_list] 
            content_tags <<  " " << global_tags
          end
          content.update_attributes(attributes.merge(:privacy_settings => auth_settings))
          content.tag_list = content_tags.strip if content_tags
          content.save
        end
      end
    end
    respond_to do |format|
      flash[:notice] = "Successfully saved selection."
      format.html { redirect_to new_content_path }
      format.js {
        render :update do |page|
          page.flash_and_fade
        end
      }
    end
  end
  
  def destroy
    @content = current_user.contents.find(params[:id])
    @content.destroy
    flash[:notice] = "Successfully destroyed content."
    respond_to do |format|
      format.html { redirect_to contents_url }
      format.js
    end
  end

  protected
  
    
end

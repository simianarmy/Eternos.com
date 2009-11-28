# $Id$

class ContentsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  session :cookie_only => false, :only => :create

  include TagsAutoComplete
  include DecorationsHelper
  
  def index
    @search = query = params[:content][:filename] rescue nil
    @contents = current_user.contents.search_text(query, params)
  end
  
  def gallery
    @parent = if params[:ref_type]
      params[:ref_type].constantize.find(params[:ref_id])
    end
    @contents = current_user.contents.search_text(params[:search])
  end
  
  def show
    @content = current_user.contents.find(params[:id])
    
    respond_to do |format|
      format.html
      format.js { render :action => :show, :layout => nil }
    end
  end
  
  def new
    @content = current_user.contents.new
    
    # Sometimes content uploads are for specific containers, ie: story elements.
    # Setup view instance vars for form create url
    if params[:ref_type]
      el = params[:ref_type].constantize.find(params[:ref_id])
      @form_url = help.build_decoration_path(el)
      @object = :decoration
    else
      @form_url = contents_path
      @object = @content
    end
  end
  
  def create
    @content = Content.factory(params[:content])
    @content.owner = current_user
    
    respond_to do |format|
      format.html {
        # If SwfUpload + Ajax upload
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
        flash[:notice] = "Updated!"
        format.html {       
          redirect_to content_path(@content) 
        }
        format.xml { head :ok }
        format.js
      else
        format.html { render :action => "show" }
        format.xml { render :xml => @content.errors,
          :status => :unprocessable_entity
        }
        format.js {
          flash[:error] = @content.errors.full_messages
          @content.reload
        }
      end
    end
  end
  
  def update_selection
    if params[:content] and !params[:content].empty?
      global_tags = filter_hint_form_value('tags', params[:tag_list]) || ""
      auth_settings = params[:content].delete(:privacy_settings)
      
      params[:content].each_pair do |content_id, attributes|
        if content = current_user.contents.find_by_id(content_id)
          # Add global tags to content tags
          content_tags = filter_hint_form_value('tags', attributes.delete(:tag_list)) || ""
          content_tags += " " + global_tags
          content.update_attributes(attributes.merge(:privacy_settings => auth_settings))
          content.tag_with(content_tags.strip, current_user) unless content_tags.blank?
          content.save
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to contents_path }
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

end

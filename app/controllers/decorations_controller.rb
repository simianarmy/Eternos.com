# $Id$
class DecorationsController < ApplicationController
  require_role "Member"
  before_filter :login_required
  before_filter :load_parent
  
  def index
    @decorations = @parent.decorations
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    if params[:content][:uploaded_data]
      @content = Content.factory(params[:content])
      @content.owner = current_user
      @content.title = params['Filename']
      result = AjaxFileUpload.save(@content)
    else
      result = AjaxFileUpload.upload_error_response('Missing File')
    end
    
    respond_to do |format|
      @parent.decorate @content if result[:status] == 'success'
      format.js { render :json => result.to_json }
    end
  end
  
  def create_from_selection
    if params[:selected_content]
      params[:selected_content].split(',').each do |id|
        if c = current_user.contents.find(id)
          @parent.decorate c
        end
      end
    end
    
    respond_to do |format|
      format.html {
        flash_redirect "Successfully added media.", request.referer
      }
    end
  end
  
  def destroy
    @decoration.destroy
    
    respond_to do |format|
      format.html {
        flash[:notice] = "Successfully destroyed decoration."
        redirect_to member_home
      }
      format.js {
        render :update do |page|
          page.visual_effect :drop_out, dom_id(@decoration)
        end
      }
    end
  end
  
  def sort
    @parent.decorations.each do |dec|
      if position = params[:decoration].index(dec.id.to_s)
        dec.update_attribute(:position, position + 1) unless dec.position == position + 1
      end
    end
    @decorations = @parent.reload.decorations
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def load_parent
    @parent = if params[:id]
      (@decoration = Decoration.find(params[:id].to_i)).decoratable
    elsif params[:owner] && params[:owner_id]
      params[:owner].classify.constantize.find(params[:owner_id].to_i)
    else
      raise ActiveRecord::RecordNotFound, 'Could not find parent object'
    end
  end
end

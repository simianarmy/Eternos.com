# $Id$
class ElementsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :find_story
  
  def index
    @elements = @story.elements.find(:all)
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @elements }
    end
  end
  
  def new
    @element = @story.elements.new
    
    respond_to do |format|
      format.html
      format.js {
        render :action => :new, :layout => false
      }
      format.xml { render :xml => @element }
    end
  end
  
  def create
    @element = @story.elements.new(params[:element])
    
    respond_to do |format|
      if @element.save
        flash[:notice] = "Element Created"
        format.html { 
          redirect_to story_element_url(@story, @element)
        }
        format.js
      else
        format.html { render :action => 'new' }
        format.js {
            flash[:error] = @element.errors.full_messages.to_sentence
          }
      end
    end
  end
  
  
  def show
    @element = @story.elements.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @element }
    end
  end
  
  def edit
    @element = @story.elements.find(params[:id])
    render :action => "show"
  end
  
  def update
    @element = @story.elements.find(params[:id])
    
    respond_to do |format|
      if @element.update_attributes(params[:element])
        flash[:notice] = 'Element successfully updated'
        format.html { redirect_to([@story, @element]) }
        format.xml { head :ok }
        format.js
      else
        format.html { render :action => "show" }
        format.xml { render :xml => @element.errors, 
          :status => :unprocessable_entity }
        format.js { 
          # simple textfield updates call helper, otherwise use update rjs
          flash[:error] = @element.errors.full_messages
          @element.reload
        }
      end
    end
  end
  
  def destroy
    @element = @story.elements.find(params[:id])
    @element.destroy
    
    respond_to do |format|
      format.html { redirect_to(story_elements_url(@story)) }
      format.xml { head :ok }
    end
  end
  
  private
  
  def find_story
    @story = current_user.stories.find(params[:story_id])
  end
end

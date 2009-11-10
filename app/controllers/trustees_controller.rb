class TrusteesController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  def index
    load_objects
    @trustee = current_user.trustees.new
  end
  
  def show
    @trustee = current_user.trustees.find(params[:id])
  end
  
  def new
    @trustee = current_user.trustees.new
  end
  
  def create
    @trustee = current_user.trustees.new(params[:trustee])
    if @trustee.save
      flash[:notice] = "Successfully created trustee."
    else
      flash[:error] = @trustee.errors.full_messages.join('<br/>')
    end
    
    respond_to do |format|
      format.js
      format.html {
        redirect_to trustees_path
      }
    end
  end
  
  def edit
    @trustee = current_user.trustees.find(params[:id])
  end
  
  def update
    @trustee = current_user.trustees.find(params[:id])
    if @trustee.update_attributes(params[:trustee])
      flash[:notice] = "Successfully updated trustee info."
    else
      flash[:error] = @trustee.errors.full_messages.join('<br/>')
      @trustee.reload
    end
    
    respond_to do |format|
      format.html { 
        redirect_to trustees_url
      }
      format.js
    end
  end
  
  def destroy
    @trustee = current_user.trustees.find(params[:id])
    @trustee.destroy
    flash[:notice] = "Removed #{@trustee.name} from list"
    
    respond_to do |format|
      format.html { 
        redirect_to trustees_url
      }
      format.js
    end
  end
  
  private
  
  def load_objects
    @trustees = current_user.trustees.find(:all)
  end
end

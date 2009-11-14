class TrusteesController < ApplicationController
  before_filter :login_required, :except => [:confirmation]
  require_role "Member", :except => [:confirmation]
  
  ssl_required :confirmation
  
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
  
  def confirmation
    if request.post?
      # confirm security code
      if params[:trustee_id]
        if @trustee = Trustee.find(params[:trustee_id])
          if !params[:security_answer].blank?
            @trustee.security_answer = params[:security_answer]
            @trustee.confirmation_answered!
            flash[:notice] = "Thank you, your answer has been recorded.  We will notify you once you have been approved by the account owner."
            redirect_to about_path
          else
            flash[:error] = "You must answer the security question"
          end
        end
      else
        flash[:error] = "Invalid security code" unless @trustee = Trustee.find_by_security_code_and_state(params[:security_code], :pending_trustee_confirmation)
      end
    end
  end
  
  private
  
  def load_objects
    @confirmed_trustees = current_user.trustees.confirmed
    @pending_trustees = current_user.trustees.pending
  end
end

class GuestInvitationsController < ApplicationController
  require_role "Member"
  before_filter :load_object, :only => [:show, :edit, :update, :destroy]

  def new
    @guest_invitation = current_user.guest_invitations.new
  end
  
  def create
    @invitation = current_user.guest_invitations.new(params[:guest_invitation])
    check_new_circle
    
    respond_to do |format|
      if @invitation.save
        flash[:notice] = 'Guest saved!'
        
        # Notify of invitation if immediate delivery selected
        if @invitation.pending?
          flash[:notice] << " An invitation by #{@invitation.contact_method} will be sent soon."
        end
        
        format.html {
          redirect_to guests_path
        }
      else
        format.html {
          @guests = current_user.loved_ones
          @invitations = current_user.guest_invitations.unconfirmed
          render :template => 'guests/index'
        }
      end
    end
  end
  
  def edit
  end
  
  def show
  end
  
  def update
    respond_to do |format|
      if @guest_invitation.update_attributes(params[:guest_invitation])
        flash[:notice] = "Guest updated!"
        format.html {
          redirect_to @guest_invitation
        }
        format.js
      else
        format.html {
          render :action => :show
        }
        format.js {
          flash[:error] = @guest_invitation.errors.full_messages
        }
      end
    end
  end
      
  def destroy
    @guest_invitation.destroy
    
    respond_to do |format|
      flash[:notice] = "Successfully destroyed guest invitation"
      format.html {
        redirect_to guests_path
      }
      format.js
    end
  end
  
  private
  
  def load_object
    @guest_invitation = current_user.guest_invitations.find(params[:id])
    check_new_circle
  end
  
  def check_new_circle
    circle_name = params[:guest_invitation][:new_circle_name] rescue ''
    @guest_invitation.circle = create_new_circle(circle_name) if !circle_name.blank?
  end
  
  def create_new_circle(name)
    Circle.find_or_create_by_name(:name => name, :user_id => current_user.id)
  end
end

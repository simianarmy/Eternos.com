# $Id$
#
# Facebook invitations controller

class InvitationsController < ApplicationController
  before_filter :ensure_authenticated_to_facebook
  layout nil
  
  ssl_allowed :new, :create
  
  def new
    @invitation = Invitation.new
  end
  
  def create
    @sent_to_ids = params[:ids]
  end
  
  protected
  
  # Used for non-facebook invitations - unused right now
  def normal_create
    @invitation = Invitation.new(params[:invitation])
    @invitation.sender = current_user
    
    if @invitation.save
      spawn do
        UserMailer.deliver_invitation(@invitation, signup_url(@invitation.token))
      end
      flash[:notice] = "Invitation sent."
      redirect_to new_invitation_path
    else
      render :action => 'new'
    end
  end
end

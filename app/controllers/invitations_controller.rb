# $Id$
class InvitationsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  def new
    @invitation = Invitation.new
  end
  
  def create
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

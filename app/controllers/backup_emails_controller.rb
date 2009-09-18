# $Id$

class BackupEmailsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  def body
    begin
      email = BackupEmail.find(params[:id])
      # Ensure proper ownership
      if email.backup_source.member == current_user
        @body = email.body
      else
        flash[:error] = 'Unauthorized Access' 
      end
    rescue
      flash[:error] = "Unexpected error: " + $!
    end
    
    respond_to do |format|
      format.js {
        render :inline => @body
      }
    end
  end
  
  
end
# $Id$

class BackupStateController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  def show
    if (bs = current_user.backup_state) && bs.in_progress
      waiting = true
      time_remaining = bs.time_remaining
    else
      waiting = false
      time_remaining = 0
    end
    
    respond_to do |format|
      format.js {
        render :json => {:waiting => waiting, :time_remaining => time_remaining}
      }
    end
  end
end

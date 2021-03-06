# $Id$

class BackupEmailsController < TimelineEventsController
 
  def body
    begin
      @email = BackupEmail.find(params[:id])
      # Ensure proper ownership
      if @email.member == current_user
        @email_body = Rails.cache.fetch(@email.to_str, @email.body, :expires_in => 10.minutes)
      else
        flash[:error] = 'Unauthorized Access' 
        @email_body = ''
      end
    rescue
      flash[:error] = "Unexpected error: " + $!
    end
    
    respond_to do |format|
      format.js # rjs
      format.html {
        render :inline => @email_body
      }
    end
  end
  
  
end
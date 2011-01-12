# $Id$

class Vault::AccountSetupController < AccountSetupController
  layout 'vault/account_setup'
  
  def index
    session[:setup_account] = true

    # Dynamic action view based on current setup step - stupid
    Rails.logger.debug "ACTIVE STEP = #{@active_step}"
    Rails.logger.debug "SETUP STEP = #{@completed_steps}"
    if @active_step <= 1
      load_online
      @content_page = 'backup_sources'
    else 
      flash[:notice] = "Account Setup Complete!"
      return redirect_to member_home_path
    end
  
    respond_to do |format|
      format.html
      format.js
    end
  end

  protected
  
  def load_facebook_app_session
    set_facebook_desktop_session
  end
end

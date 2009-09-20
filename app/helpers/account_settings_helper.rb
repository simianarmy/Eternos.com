module AccountSettingsHelper
  def needs_account_setup(user)
    (user.login_count == 1) && session[:setup_account].nil?
  end
  
  def setup_layout_account_setting(page, partial_content)
    page.replace "account-setting-content", :partial => partial_content, :layout => false
    page.call 'setDinamycHeight', 'account-setting-content';
    page.call 'Scroller.setAll'
  end
  
  def call_update_step_js(steps)
    "updateStep('#{completed_steps_account_setting_path(current_user)}', #{steps});"
  end
end
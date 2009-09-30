module AccountSettingsHelper
  
  def update_account_settings_layout(page, partial_content)
    page.replace "account-setting-content", :partial => partial_content, :locals => {:settings => @settings},
      :layout => false
    page.call 'setDinamycHeight', 'account-setting-content'
    page.call 'Scroller.setAll'
  end
  
  def call_update_step_js(steps)
    "updateStep('#{completed_steps_account_setting_path(current_user)}', #{steps});"
  end
end
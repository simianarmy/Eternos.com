module AccountSettingsHelper
  def update_account_settings_layout(page, partial_content, settings=@settings)
    page.replace "account-setting-content", :partial => partial_content, :locals => {:settings => @settings},
      :layout => false
    page.call 'setDinamycHeight', 'account-setting-content'
    page.call 'Scroller.setAll'
  end
  
  def call_update_step_js(steps)
    "updateStep('#{completed_steps_account_setting_path(current_user)}', #{steps});"
  end
  
  def link_to_new_profile_entry(name, locals={})
    link_to_function "+ Add New" do |page|
      page.replace_html "#{name}_container", :partial => name, :locals => locals
    end
  end
end

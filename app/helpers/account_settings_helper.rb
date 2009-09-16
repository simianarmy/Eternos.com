module AccountSettingsHelper
  def needs_account_setup(user)
    (user.login_count == 1) && session[:setup_account].nil?
  end
  
  def setup_layout_account_setting(page, active_link, partial_content)
    page.replace "account-setting-nav", :partial => "account_settings/setting_nav",
      :locals => {:active_link => active_link }, :layout => false
    page.replace "account-setting-content", :partial => partial_content, :layout => false
  end
end
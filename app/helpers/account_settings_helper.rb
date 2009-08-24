module AccountSettingsHelper
  def needs_account_setup(user)
    (user.login_count == 1) && session[:setup_account].nil?
  end
end
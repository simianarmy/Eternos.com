module SubdomainHelper
  # Subdomain based path generators
  
  def get_login_path
    current_subdomain == 'vault' ? vlogin_path : login_path
  end
  
  def get_logout_path
    current_subdomain == 'vault' ? vlogout_path : logout_path
  end
  
  def get_signup_path(opts={})
    current_subdomain == 'vault' ? new_account_registration_path(opts) : new_account_url(opts)
  end
end

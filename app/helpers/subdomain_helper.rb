module SubdomainHelper
  # Subdomain based path generators
  
  def get_login_path
    current_subdomain == 'vault' ? vlogin_path : login_path
  end
  
  def get_logout_path
    current_subdomain == 'vault' ? vlogout_path : logout_path
  end
end

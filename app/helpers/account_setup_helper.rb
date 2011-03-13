# $Id$

module AccountSetupHelper
  
  def needs_account_setup(user)
    user.setup_step < 2 #0 && session[:setup_account].nil?
  end
  
  def get_signup_wizard_step_class(is_active)
    is_active ? 'signup-active' : 'signup-inactive'
  end
  
  def account_delete_confirmation
    'Are you sure?  All data and documents related to this account will be deleted permanently!'
  end
end

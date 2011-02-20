class AdminsController < ApplicationController
  require_role "Admin"
  layout 'admin'
  
  protected
  
  def admin_subdomain?
    true
  end
end
# $Id$
class MemberHomeController < ApplicationController
  ssl_allowed :index
  before_filter :login_required
  require_role "Member"
  
  def index
    @name = current_user.name
  end
  
end

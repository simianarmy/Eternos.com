# $Id$
class MemberHomeController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :ssl_prohibited, :only => [:index]
  
  def index
    @name = current_user.name
  end
  
  def test_lightview
  end
end

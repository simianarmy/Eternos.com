# $Id$
class MemberHomeController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :set_facebook_connect_session
  before_filter :load_member_home_presenter
  
  def index
    @name = current_user.name
  end
    
end

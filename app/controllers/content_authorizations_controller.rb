# $Id$
class ContentAuthorizationsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  def update
    obj = ContentAuthorization.find_by_authorizable_id(params[:id])
  end
end

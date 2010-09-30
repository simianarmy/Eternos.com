# $Id$

class EmailListsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  ssl_allowed :all
  
  def update
    if params[:email_list]
      @list = current_user.email_lists.find_or_create_by_name(params[:email_list][:name])
      @list.update_attributes(params[:email_list])
    end
    respond_to do |format|
      format.js {
        render :nothing => true, :status => :ok
      }
    end
  end
end

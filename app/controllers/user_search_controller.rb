# $Id$

require 'user_search'

class UserSearchController < ApplicationController
  before_filter :login_required
  require_role 'Member'
  
  def new
  end
  
  def show
    # support more than just search terms in the future
    BenchmarkHelper.rails_log("sphinx search for #{params[:terms]}") do
      @results = UserSearch.new(current_user).execute params[:terms]
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
  
end

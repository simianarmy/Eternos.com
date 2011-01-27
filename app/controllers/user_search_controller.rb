# $Id$

require 'user_search'

class UserSearchController < ApplicationController
  before_filter :login_required
  require_role 'Member'
  
  ssl_allowed :show
  
  def new
  end
  
  def show
    # support more than just search terms in the future\
    @results = []
    unless params[:terms].blank?
      BenchmarkHelper.rails_log("sphinx search for #{params[:terms]}") do
        @results = UserSearch.new(current_user).execute(params[:terms]).compact
      end
    end
    
    RAILS_DEFAULT_LOGGER.debug "sphinx results: #{@results.inspect}"
    respond_to do |format|
      format.html
      format.js 
    end
  end
  
end

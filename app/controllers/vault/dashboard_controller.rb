class Vault::DashboardController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :load_member_home_presenter, :only => [:index]

  layout 'vault/private/dashboard'

  ssl_required :all

  def index
    @dashboard = DashboardPresenter.new(current_user)
    @backup_data = @dashboard.backup_data_counts
  end
  
  def search
    @search_terms = params[:terms]
    @results = []
    search_attributes = {}
    refresh = params[:no_cache] || force_cache_reload?(:timeline) || false
    md5 = [Digest::MD5.hexdigest(request.url), current_user.id].join(':')
    
    # Cache search results for 10 minutes
    @results += Rails.cache.fetch(md5, :force => refresh, :expires_in => 10.minutes) do
      # Date-based search uses TimelineSearch module (db search)
      if @search_terms.blank?
        TimelineSearch.new(current_user.id, [4.months.ago, Date.today], :raw_results => true).results
      else # Term-based search uses UserSearch module (sphinx search)
        UserSearch.new(current_user).execute(@search_terms, search_attributes).compact
      end
    end
    @results.sort! {|a,b| b.start_date <=> a.start_date }
    
    # View hacks
    @readonly = true # Instruct views not to make data editable
    @hide_close = true # Do not show close button in search result details view
    
    respond_to do |format|
      format.html { 
        render :layout => false
      }
    end
  end
  
  protected
  
end
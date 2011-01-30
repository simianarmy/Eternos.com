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
    
    if @search_terms.blank?
      search_attributes.merge!({:created_at => 12.months.ago.utc..Time.now.utc, :user_id=>178})
    end
    BenchmarkHelper.rails_log("sphinx search for #{@search_terms} with #{search_attributes.inspect}") do
      @results = UserSearch.new(current_user).execute(@search_terms, search_attributes).compact
    end
    
    respond_to do |format|
      format.html { 
        render :layout => false
      }
    end
  end
  
  protected
  
end
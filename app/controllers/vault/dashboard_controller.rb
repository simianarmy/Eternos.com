class Vault::DashboardController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :load_member_home_presenter

  layout 'vault/private/dashboard'

  ssl_required :all

  def index
    @dashboard = DashboardPresenter.new(current_user)
    @backup_data = @dashboard.backup_data_counts
  end
  
  def search
    @results = []
    unless params[:terms].blank?
      BenchmarkHelper.rails_log("sphinx search for #{params[:terms]}") do
        @results = UserSearch.new(current_user).execute(params[:terms]).compact
      end
    end
    
    respond_to do |format|
      format.html { 
        render :layout => false
      }
    end
  end
  
  protected
  
end
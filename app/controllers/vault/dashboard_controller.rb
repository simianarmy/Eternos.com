class Vault::DashboardController < ApplicationController
  before_filter :login_required
  require_role "Member"
  before_filter :load_member_home_presenter

  layout 'vault/dashboard'

  ssl_required :all

  def index
    @dashboard = DashboardPresenter.new(current_user)
    @backup_data = @dashboard.backup_data_counts
  end
end
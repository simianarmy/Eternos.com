# $Id$

# DashboardPresenter module
#
class DashboardPresenter < Presenter
  include BackupSourceHistory
  
  attr_accessor :user_name, :account_state, :days_signed_up, :birthday, :backup_sites
  
  def initialize(user)
    @user = user
    
    @user_name = user.full_name
    @days_signed_up = (Date.current - @user.created_at.to_date + 1).to_i.to_s
    @birthday = @user.profile.birthday.to_date rescue ''
    @account_state = user.state.to_s.capitalize
    @backup_sites = user.backup_sources.map do |bs|
      status = if bs.active?
        'OK'
      elsif auth_required?
        'Authentication Required'
      elsif backup_broken?
        'Too many failed attempts'
      else
        'Inactive'
      end
      # Return simple hash with backup source info
      {:description => bs.description,
        :created_at => bs.created_at.to_date,
        :last_backup_at => (bs.latest_backup ? bs.latest_backup.finished_at : bs.last_backup_at).to_date,
        :status => status}
    end
    Rails.logger.debug "backup sites: #{@backup_sites.inspect}"
  end
  
  def backup_data_counts
    @backup_data ||= get_data_counts(@user)
  end
end
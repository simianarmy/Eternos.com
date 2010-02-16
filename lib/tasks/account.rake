# $Id$

# Tasks related to Users & Accounts

namespace :account do
  desc =<<DESC 
  Notifies inactive accounts that they have an account with us.
  Inactive = member for > cutoff days but no backup sites or no backup data for > cutoff days
DESC
  task :notify_inactive => :environment do
    cutoff = (ENV['CUTOFF_DAYS'] || 14).to_i # days
    User.active.each do |user|
      if (user.backup_sources.active.empty? || user.backup_state.inactive?(cutoff)) && 
        ((Time.now - user.activated_at) > cutoff)
        RAILS_DEFAULT_LOGGER.info "#{user.id} is inactive...sending email"
        UserMailer.deliver_inactive_notification(user)
      end
    end
  end
end
      
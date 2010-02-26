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
        # Skip if emailed about this recently
        if (u = UserMailing.recipients_eq(user.email).subject_like(UserMailer.subject(:inactive_notification)).descend_by_sent_at.first) && 
          ((Time.now.utc - u.sent_at) < cutoff.days)
          RAILS_DEFAULT_LOGGER.debug "Last email sent at #{u.sent_at} - not sending."
          next
        end
        RAILS_DEFAULT_LOGGER.info "#{user.id} is inactive...sending email"
        UserMailer.deliver_inactive_notification(user)
        break
      end
    end
  end
  
  desc "run housekeeping tasks on accounts (run daily)"
  task :daily_housekeeping => :environment do
    Rake::Task["backup:disable_failed_backup_sources"].invoke
    # notify_inactive
  end
end
      
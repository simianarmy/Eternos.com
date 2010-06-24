# $Id$

# Tasks related to Users & Accounts

namespace :account do

  def gen_account_setup_onetime_url(user)
  end
  
  desc =<<DESC 
  Notifies inactive accounts that they have an account with us.
  Inactive = member for > cutoff days but no backup sites or no backup data for > cutoff days
DESC
  task :notify_inactive => :environment do
    cutoff = (ENV['CUTOFF_DAYS'] || 14).to_i # days
    
    Member.active.each do |user|
      if user.backup_state.inactive?(cutoff) && ((Time.now - user.activated_at) > cutoff)
        # Skip if emailed about this recently
        if (u = UserMailing.most_recent_by_email_and_subject(user.email, UserMailer.subject(:inactive_notification))) && 
          ((Time.now.utc - u.sent_at) < cutoff.days)
          RAILS_DEFAULT_LOGGER.debug "Last email sent at #{u.sent_at} - not sending."
          next
        end
        RAILS_DEFAULT_LOGGER.info "#{user.id} is inactive...sending email"
        user.deliver_inactive_notification!
        break
      end
    end
  end
  
  desc "run housekeeping tasks on accounts (run daily)"
  task :daily_housekeeping => :environment do
    Rake::Task["backup:disable_failed_backup_sources"].invoke
  end
  
  desc "Sends email notification to accounts that need setup completed"
  task :notify_account_setup_incomplete => :environment do
    cutoff = (ENV['CUTOFF_DAYS'] || 14).to_i # days
    
    Member.active.each do |user|
      if user.backup_sources.active.empty? && ((Time.now - user.activated_at) > cutoff)
        # Skip if emailed about this recently
        if u = UserMailing.most_recent_by_email_and_subject(user.email, UserMailer.subject(:account_setup_reminder))
          Rails.logger.debug "Found recent mailing: #{u.inspect}"
          if (Time.now.utc - u.sent_at) < cutoff.days
            Rails.logger.debug "Last email sent at #{u.sent_at} - not sending."
            next
          end
        end

        Rails.logger.info "#{user.email} has no backup sources...sending email"
        user.deliver_account_setup_reminder!
        break
      end
    end
  end
  
  desc "Permanently removes member account with all contents"
  task :destroy => :environment do
    unless id=ENV['USER_ID']
      puts "Usage: rake account:destroy USER_ID=XX"
      exit
    end
    User.find(id).destroy
  end
end
      
# $Id$

# Tasks related to Users & Accounts

namespace :account do

  def gen_account_setup_onetime_url(user)
  end
  
  # ACCOUNT EMAIL NOTIFICATION TASKS
  namespace :mailer do 
    # Parse common env variables
    def parse_env
      @dry_run = !(ENV['DO_IT'] == '1') # FORCE ENV SET TO GUARD AGAINST STUPIDITY
      puts "Dry run only" if @dry_run
      
      @cutoff = ENV['MIN_ACTIVE_DAYS'] || 14 # WAIT AT LEAST 2 WEEKS FROM JOIN DATE BEFORE BUGGING THEM
      puts "Only emailing members > #{@cutoff} days old"
      
      @max = ENV['MAX']
      @debug = ENV['DEBUG']
    end
    
    # TODO: This is incomplete...figure out what it will be do!
    desc =<<DESC 
    Notifies inactive accounts that they have an account with us.
    Inactive = member for > cutoff days but no backup sites or no backup data for > cutoff days
DESC
    task :notify_inactive => :environment do
      require 'eternos_mailer/mail_manager'
      
      mailing = MailManager::Mailing.new(:inactive_notification, ENV['CUTOFF_DAYS'])
      mailer = MailManager::BatchMailer.new(ENV['MAX'])
      cutoff = 14
      
      mailer.recipients = Member.active.select do |user|
        user.backup_state.inactive?(cutoff) && ((Time.now - user.activated_at) > cutoff) && 
        mailing.allowed?(user.email)
      end
      sent = mailer.send do |user|
        Rails.logger.info "#{user.id} is inactive...sending email"
        user.deliver_inactive_notification!
      end
    end
    
    # Mailer for members who have not added any backup sources
    desc "Sends email notification to accounts that do not have any backup sources added"
    task :notify_account_setup_incomplete => :environment do
      require 'eternos_mailer/mail_manager'
      
      parse_env
      mailing = EternosMailer::MailManager::Mailing.new(:account_setup_reminder)
      mailer = EternosMailer::MailManager::BatchMailer.new(:max => @max, 
        :dry_run => @dry_run, 
        :debug => @debug)
      
      mailer.recipients = Member.active.activated_at_lt(@cutoff.days.ago).select do |user|
        user.backup_sources.empty? && mailing.allowed?(user.email)
      end
      mailer.send { |user| user.deliver_account_setup_reminder! }
      mailer.print_summary
    end
    
    # Mailer for members who have not added any backup sources
    desc "Sends email notification to accounts that have too many backup errors"
    task :notify_backup_errors => :environment do
      require 'eternos_mailer/mail_manager'

      mailing = EternosMailer::MailManager::Mailing.new(:account_setup_reminder)
      mailer = EternosMailer::MailManager::BatchMailer.new(:max => ENV['MAX'], 
        :dry_run => dry_run, :debug => ENV['DEBUG'])
    end
    
  end
  
  desc "run housekeeping tasks on accounts (run daily)"
  task :daily_housekeeping => :environment do
    Rake::Task["backup:disable_failed_backup_sources"].invoke
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
      
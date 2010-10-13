# $Id$
#
# EternosMailer module
#
# Contains modules and classes responsible for mailings to various mailing lists.

module EternosMailer
  # Set this to true to see all the email addresses that will be sent for
  # target mailing
  @@dry_run_mode  = false
  
  # Set this to tru to see counts of emails that would be sent for target 
  # mailing
  @@counts_only   = false

  mattr_accessor :dry_run_mode, :counts_only
  
  # Contains mailer subject constants and lookup helper methods
  module Subjects
    # Constant hash of mail subject symbol => subject strings
    # Including classes use this for setting the mailer subject.
    # Access strings via the subject() method
    @@Subjects = {
      :signup_notification    => 'Activate Your Eternos.com Account',
      :activation             => 'Your account has been activated!',
      :invitation             => 'Invitation From Eternos.com',
      :inactive_notification  => 'Inactive Account Notice',
      :account_setup_reminder => 'Complete your Eternos.com Account Setup',
      :friend_invitation      => 'Invitation to Eternos.com',
      :timeline_ready         => 'Your Eternos Timeline is ready!',
      :backup_errors          => 'Your Backup Has Errors'
    }
  
  
    # Lookup email subject string by title (ideally title = mailer action)
    def subject_from_sym(action)
      @@Subjects[action.to_sym]
    end
  end
  
  # MailManager module
  #
  # Implements mailing-list management interface that encapsulates logic 
  # for sending mass emails to groups of users.  Handles checking for 
  # mailing list removal requests & updates sent mail stats.

  module MailManager
    # The mininum # days a user can receive emails for a single subject
    @@default_min_days_between_emails = 31
  
    mattr_reader :default_min_days_between_emails
  
    # Mailing class
    #
    # Encapsulates email sending to a user for some subject
    #
    class Mailing
      include EternosMailer::Subjects
      
      attr_reader :cutoff_time
      
      def initialize(subject_sym, cutoff_date=nil)
        @subject      = subject_from_sym(subject_sym)
        @cutoff_time  = cutoff_date || MailManager.default_min_days_between_emails.days.ago.utc
      end
    
      # Checks if mailings table to determine if mailing can be sent to this user
      def allowed?(email)
        # Check Do-not-mail list
        return false if EmailBlacklist.find_by_email(email)
        # Check recent mailing time for this email/subject
        not ((u = UserMailing.most_recent_by_email_and_subject(email, @subject)) && 
          (u.sent_at >= cutoff_time))
      end
    end # MailManager
  
    # BatchMailer class
    #
    # Sends bulk emails
    
    class BatchMailer
      attr_reader :sent, :run_time
      attr_accessor :recipients
    
      def initialize(options={})
        @limit      = (options[:max] || 0).to_i
        @dry_run    = options[:dry_run] || false
        @debug      = options[:debug] || false
        @verbose    = options[:verbose] || false
        @sent       = 0
        @run_time   = 0
        @recipients = []
      end
    
      # Sends email to list of users using passed block as delivery method
      def send(&block)
        @recipients.each do |user|
          puts "Sending email to user #{user.id}."
          begin
            unless @dry_run || ::EternosMailer.dry_run_mode
              puts user.email if @debug
              @run_time += Benchmark.realtime { block.call(user) }
              puts "delivered." if @debug
              sleep(2) # Some smtp servers will block us if we send too many too fast (Google Apps)
            end
            @sent += 1
          rescue Timeout::Error => e
            Rails.logger.error e.message
          rescue Exception => e
            Rails.logger.error e.message
          end
          break if (@limit > 0) && (@sent >= @limit)
        end
        @sent
      end
      
      def print_summary
        puts "#{sent} emails sent in #{run_time} secs."
      end
    end # class BatchMailer
  end # module MailManager

end # module EternosMailer
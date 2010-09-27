# $Id$
#
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
    attr_reader :cutoff_time, :subject
    
    def initialize(subject_sym, cutoff_date=nil)
      @subject      = UserMailer.subject(subject_sym)
      @cutoff_time  = cutoff_date || MailManager.default_min_days_between_emails.days.ago.utc
    end
    
    # Checks if mailings table to determine if mailing can be sent to this user
    def allowed?(email)
      # Check Do-not-mail list
      not (EmailBlacklist.find_by_email(email) && 
        # Check recent mailing time for this email/subject
        (u = UserMailing.most_recent_by_email_and_subject(email, subject)) && 
        (u.sent_at >= cutoff_time))
    end
  end
  
  # BatchMailer class
  #
  # Sends bulk emails
  class BatchMailer
    attr_reader :sent
    attr_writer :recipients
    
    def initialize(limit=0)
      @limit      = limit
      @sent       = 0
      @recipients = []
    end
    
    # Sends email to list of users using passed block as delivery method
    def send(&block)
      @recipients.each do |user|
        begin
          block.call(user)
          @sent += 1
          sleep(2) # Some smtp servers will block us if we send too many too fast (Google Apps)
        rescue Timeout::Error => e
          Rails.logger.error e.message
        rescue Exception => e
          Rails.logger.error e.message
        end
        break if (@limit) > 0 && (@sent >= @limit)
      end
      @sent
    end
  end    
end

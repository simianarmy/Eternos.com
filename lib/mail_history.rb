# $Id$

# Mixin for ActiveMailer classes that saves emails after delivery to custom table

module MailHistory
  class UserMailing < ActiveRecord::Base
  end
  
  def self.included(base)
    base.class_eval do
      after_deliver :save_email
      
      def save_email
        MailHistory::UserMailing.create(:recipients => @recipients.to_s, :mailer => self.class.to_s, :subject => @subject, :sent_at => Time.now)
      end
    end
  end
end

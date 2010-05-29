# $Id$

# Mixin for ActiveMailer classes that saves emails after delivery to custom table

class UserMailing < ActiveRecord::Base
end

module MailHistory
  def self.included(base)
    base.class_eval do
      after_deliver :save_email
      
      def save_email
        UserMailing.create(:recipients => @recipients.to_s, :mailer => self.class.to_s, :subject => @subject, :sent_at => Time.now)
      end
      
      def add_category_header(category)
        @headers["X-SMTPAPI"] = {"category" => category}.to_json
      end
    end
  end
end

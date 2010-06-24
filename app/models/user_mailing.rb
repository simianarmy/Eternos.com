# $Id$

class UserMailing < ActiveRecord::Base
  # Finder helpers
  def self.count_by_email_and_subject(email, subject)
    UserMailing.recipients_eq(email).subject_like(subject).count
  end
  
  def self.most_recent_by_email_and_subject(email, subject)
    UserMailing.recipients_eq(email).subject_like(subject).descend_by_sent_at.first
  end

end
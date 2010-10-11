# $Id$

class BackupNotifier < ActionMailer::Base
  layout 'email'
  include MailHistory
  
  @@Subjects = {
    :timeline_ready => 'Backup Data Ready',
    :backup_errors => 'Your Backup Has Errors'
  }
  
  def self.subject(action)
    @@Subjects[action.to_sym]
  end
  
  def timeline_ready(member)
    setup_email(member)
    @subject      = "Your #{AppConfig['app_name']} Timeline is ready!"
   
    add_category_header "Backup Data Ready"
  end
  
  def backup_errors(member, sources)
    setup_email(member)
    @subject  = "Error Backing Up Your Accounts"
    @errors = sources
    
    add_category_header "Backup Errors"
  end
  
  protected
  
  def setup_email(member)
    @from         = AppConfig['from_email']
    @recipients   = member.email
    @sent_on      = Time.now
    @content_type = "text/html"
  end
end
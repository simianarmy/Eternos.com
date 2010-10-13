# $Id$

class BackupNotifier < ActionMailer::Base
  layout 'email'
  include MailHistory
  include EternosMailer::Subjects
  
  def timeline_ready(member)
    setup_email(member)
    @subject      = subject_from_sym(:timeline_ready)
   
    add_category_header "Backup Data Ready"
  end
  
  def backup_errors(member, sources)
    setup_email(member)
    @subject  = subject_from_sym(:backup_errors)
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
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
    
    @recipients     = 'marc@eternos.com'
    @subject        = subject_from_sym(:backup_errors)
    @body[:errors]  = sources
    @body[:name]    = member.full_name || 'Eternos Member'
    @body[:setup_url] = account_setup_url
    
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
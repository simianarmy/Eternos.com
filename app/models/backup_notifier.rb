# $Id$

class BackupNotifier < ActionMailer::Base
  layout nil
  include MailHistory
  
  def timeline_ready(member)
    @from         = AppConfig['from_email']
    @recipients   = member.email
    @subject      = "Your #{AppConfig['app_name']} Timeline is ready!"
    @sent_on      = Time.now
    @content_type = "text/html"
    add_category_header "Backup Data Ready"
  end
end
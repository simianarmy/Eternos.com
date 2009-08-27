# $Id$

class BackupNotifier < ActionMailer::Base
  layout 'email'
  
  def timeline_ready(member)
    @from         = AppConfig['from_email']
    @recipients   = member.email
    @subject      = "Your #{AppConfig['app_name']} Timeline is ready!"
    @sent_on      = Time.now
    @content_type = "text/html"
  end
end
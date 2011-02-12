# $Id$

class Vault::UserMailer < UserMailer
  layout 'vault/email'
  include MailHistory
  include EternosMailer::Subjects
  
  def activation(user)
    setup_email(user)
    @subject          += subject_from_sym :activation
    base_domain       = "http://vault.eternos.com"
    body[:login]      = user.login
    add_category_header "Activation Confirmation"
  end
  
  protected
  
  def setup_email(user)
    @user = user
    @recipients  = "#{user.email}"
    @from        = AppConfig.from_email
    @subject     = "[vault.eternos.com] "
    @sent_on     = Time.now
    @body[:user] = user
    @content_type = "text/html"
  end
end

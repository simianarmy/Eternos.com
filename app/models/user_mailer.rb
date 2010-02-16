# $Id$
class UserMailer < ActionMailer::Base
  layout 'email'
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{AppConfig.base_domain}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    = "Your #{AppConfig.app_name} account has been activated!"
    @user = user
    base_domain = "http://" + AppConfig.base_domain
  end
  
  def invitation(invitation, signup_url)
    subject 'Invitation From Eternos.com'
    recipients  invitation.recipient_email
    from  "#{AppConfig.from_email}"
    reply_to "#{AppConfig.support_email}"
    body  :invitation => invitation, :signup_url => signup_url

    invitation.update_attribute(:sent_at, Time.now)
  end
  
  def inactive_notification(user)
    setup_email(user)
    @recipients   = 'marc@eternos.com'
    @subject      += "Your Account"
    @body[:name]  = user.full_name || 'Eternos user'
    @body[:link]  = account_setup_url
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = AppConfig.from_email
      @subject     = "[#{AppConfig.base_domain}] "
      @sent_on     = Time.now
      @body[:user] = user
      @content_type = "text/html"
    end
end

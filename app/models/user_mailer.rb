# $Id$
class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{AppConfig.base_domain}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @user = user
    @body[:url]  = url_for(:controller => "images") #"http://#{AppConfig.base_domain}/"
    @body[:supoort_url] = url_for(:controller => "about", :action => "contact")
    @body[:manage_url] = url_for(:controller => "member_home")
  end
  
  def invitation(invitation, signup_url)
    subject 'Eternos.com Invitation'
    recipients  invitation.recipient_email
    from  "#{AppConfig.from_email}"
    body  :invitation => invitation, :signup_url => signup_url
    invitation.update_attribute(:sent_at, Time.now)
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

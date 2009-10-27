class TrusteeMailer < ActionMailer::Base
  def confirmation_request(user, emails)
    subject 'Trustee Request From Eternos.com'
    recipients emails
    from  "#{AppConfig.from_email}"
    reply_to "#{AppConfig.support_email}"
    
    body :foo => 'boo'
  end
end
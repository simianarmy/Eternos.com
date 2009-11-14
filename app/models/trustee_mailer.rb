class TrusteeMailer < ActionMailer::Base
  layout 'email'
  
  def confirmation_request(user, trustee)
    subject 'Eternos.com Trustee Request'
    recipients trustee.emails
    from  "#{AppConfig.from_email}"
    reply_to "#{AppConfig.support_email}"
    
    body :sender => user.full_name,
      :trustee_name => trustee.name,
      :security_code => trustee.security_code,
      :confirmation_url => confirmation_trustees_url,
      :support_url => home_url('support')
  end
end
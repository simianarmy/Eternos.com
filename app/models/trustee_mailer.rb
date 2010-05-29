# $Id$

class TrusteeMailer < ActionMailer::Base
  layout nil
  include MailHistory
  
  def confirmation_request(user, trustee)
    setup_email(user, trustee)
    recipients trustee.emails
    subject 'Eternos.com - Trustee: Verification Request'
  end
  
  def user_confirmation_request(user, trustee)
    setup_email(user, trustee)
    recipients user.email
    subject 'Eternos.com - Verify Trustee'
  end
  
  def confirmation_approved(user, trustee)
    setup_email(user, trustee)
    recipients trustee.emails
    subject 'Eternos.com - Trustee: Approved'
  end
  
  protected
  
  def setup_email(user, trustee)
    add_category_header "Life Key"
    from  "#{AppConfig.from_email}"
    reply_to "#{AppConfig.support_email}"
    
    body :sender => user.full_name,
      :trustee_name => trustee.name,
      :security_code => trustee.security_code,
      :personal_note => trustee.personal_note,
      :confirmation_url => confirmation_trustees_url,
      :support_url => home_url('support')
  end
end
# $Id$

# Mailers related to Member-created Guests

class GuestMailer < ActionMailer::Base
  include MailHistory
  
  def invitation(invitation, signup_url)
    sender = invitation.sender
    subject I18n.t('mailers.guest.invitation.subject', :sender => invitation.sender.full_name)
    recipients invitation.email
    from  "#{AppConfig.from_email}"
    body  :sender => sender, :signup_url => signup_url
  end  
end

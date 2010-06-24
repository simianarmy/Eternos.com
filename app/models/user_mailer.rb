# $Id$

class UserMailer < ActionMailer::Base
  layout nil
  include MailHistory
  
  @@Subjects = {
    :signup_notification    => 'Please activate your new account',
    :activation             => 'Your account has been activated!',
    :invitation             => 'Invitation From Eternos.com',
    :inactive_notification  => 'Inactive Account Notice',
    :account_setup_reminder => 'Complete your Eternos.com Account Setup',
    :friend_invitation      => 'Invitation to Eternos.com'
  }
  
  def self.subject(action)
    @@Subjects[action.to_sym]
  end
  
  def signup_notification(user)
    setup_email(user)
    @subject          += @@Subjects[:signup_notification]
    @body[:name]      = user.full_name || 'Eternos user'
    @body[:url]       = "http://#{AppConfig.base_domain}/activate/#{user.activation_code}"
    @body[:facebook]  = !user.facebook_id.nil?
    @body[:login]     = user.login
    add_category_header "Activation Request" 
  end
  
  def activation(user)
    setup_email(user)
    @subject    += @@Subjects[:activation]
    base_domain = "http://" + AppConfig.base_domain
    body[:login]  = user.login
    add_category_header "Activation Confirmation"
  end
  
  def invitation(invitation, signup_url)
    @subject    = @@Subjects[:invitation]
    @recipients = invitation.recipient_email
    @from       = "#{AppConfig.from_email}"
    @reply_to   = "#{AppConfig.support_email}"
    @body[:invitation] = invitation
    @body[:signup_url] = signup_url

    invitation.update_attribute(:sent_at, Time.now)
  end
  
  def inactive_notification(user)
    setup_email(user)
    @recipients   = 'marc@eternos.com'
    @subject      += @@Subjects[:inactive_notification]
    @body[:name]  = user.full_name || 'Eternos user'
    @body[:link]  = account_setup_url
    add_category_header "Inactive Account Notice"
  end

  def friend_invite(user, to, invite_url)
    # Use sendmail when sending friend invites so that From address can be set to 
    # the current user's email address.  
    # Google Apps won't allow custom From's that it doesn't know about
    recipients    to
    from          user.email
    @headers['Reply-To'] = user.email
    @headers['From']     = user.email
    sent_on       Time.now
    subject       "[#{user.name}] Check out Eternos.com"
    body          :user => user, :signup_url => invite_url
    content_type "text/html" 
    add_category_header "Invites"
  end
  
  def account_setup_reminder(user)
    setup_email(user)
    @recipients         = 'eric@eternos.com'
    @subject            +=  @@Subjects[:account_setup_reminder]
    @body[:name]        = user.full_name
    @body[:setup_url]   = account_setup_url(:id => user.perishable_token, :protocol => 'https')
    add_category_header "Account Setup Reminder"
  end
  
  protected
  
  def setup_email(user)
    @user = user
    @recipients  = "#{user.email}"
    @from        = AppConfig.from_email
    @subject     = "[#{AppConfig.base_domain}] "
    @sent_on     = Time.now
    @body[:user] = user
    @content_type = "text/html"
  end
end

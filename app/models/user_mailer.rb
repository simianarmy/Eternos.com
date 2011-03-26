# $Id$

class UserMailer < ActionMailer::Base
  #layout nil
  layout 'email'
  include MailHistory
  include EternosMailer::Subjects
  
  def signup_notification(user)
    setup_email(user)
    
    @subject          += subject_from_sym :signup_notification
    @body[:name]      = user.full_name || 'Eternos user'
    @body[:url]       = "http://#{AppConfig.base_domain}/activate/#{user.activation_code}"
    @body[:facebook]  = !user.facebook_id.nil?
    @body[:login]     = user.login
    
    # If co-reg user, add link to special password-setting login page
    if user.using_coreg_password?
      @body[:choose_passwd_login_url]    = choose_password_user_sessions_url(:protocol => 'https')
    end
    add_category_header "Activation Request" 
  end
  
  def activation(user)
    setup_email(user)
    @subject          += subject_from_sym :activation
    base_domain       = "http://" + AppConfig.base_domain
    body[:login]      = user.login
    add_category_header "Activation Confirmation"
  end
  
  def invitation(invitation, signup_url)
    @subject    = subject_from_sym :invitation
    @recipients = invitation.recipient_email
    @from       = "#{AppConfig.from_email}"
    @reply_to   = "#{AppConfig.support_email}"
    @body[:invitation] = invitation
    @body[:signup_url] = signup_url

    invitation.update_attribute(:sent_at, Time.now)
  end
  
  # MUST BE CALLED BY User.deliver_inactive_notification!
  def inactive_notification(user)
    setup_email(user)
    
    @subject      += subject_from_sym :inactive_notification
    @body[:name]  = user.full_name || 'Eternos user'
    @body[:link]  = account_setup_url(:id => user.perishable_token)
    add_category_header "Inactive Account Notice"
  end

  def friend_invite(user, to, invite_url)
    # Use sendmail when sending friend invites so that From address can be set to 
    # the current user's email address.  
    # Google Apps won't allow custom From's that it doesn't know about
    setup_email(user)
    
    @recipients   = to
    @from         = user.email
    @headers['Reply-To'] = user.email
    @headers['From']     = user.email
    @subject      = "[#{user.name}] Check out Eternos.com"
    body          :signup_url => invite_url

    add_category_header "Invites"
  end
  
  # MUST BE CALLED BY User.deliver_account_setup_reminder!
  def account_setup_reminder(user)
    setup_email(user)
    
    @subject            = subject_from_sym :account_setup_reminder
    @body[:name]        = user.full_name
    @body[:setup_url]   = account_setup_url(:id => user.perishable_token, :ref => 'asr1')
    
    add_category_header "Account Setup Reminder"
  end
  
  def test
    recipients    'eric@eternos.com'
    subject       "nothing bad here"
    from          "support@eternos.com"
    sent_on       Time.now
    content_type  "text/plain"
    add_category_header "Test"
  end

  def backup_stats(user, backups, period = 'weekly')
    setup_email(user)
    @name = user.full_name
    if (period == 'weekly') then
      @period = 'week'
      start_time = Time.now.to_date - 6
    else
      #monthly
      @period = 'month'
      start_time = (Time.now.to_date << 1) + 1
    end
    format_date = lambda {|date| Date::ABBR_MONTHNAMES[date.month] + ' ' + date.day.to_s }
    @date_range = format_date.call(start_time) + ' - ' + format_date.call(Time.now.to_date)
    @num_errors = 0
    @num_facebook_items = backups[:fb]
    @num_tweets = backups[:tweets]
    @num_photos = backups[:photos]
    @num_emails = backups[:emails]
    @num_rss_items = backups[:rss]
  end
  
  def loyalty_signup_request(user)
    setup_email(user)
    
    @subject            = subject_from_sym :loyalty_signup
    @body[:name]        = user.full_name
    # Shorten persistence_token to prevent bad email formatting of url
    @body[:billing_url] = upgrade_loyalty_subscriptions_url(:pt => Digest::MD5.hexdigest(user.persistence_token))
    
    render :layout => false
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

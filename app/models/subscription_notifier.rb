class SubscriptionNotifier < ActionMailer::Base
  include ActionView::Helpers::NumberHelper
  
  def setup_email(to, subject, from = AppConfig['from_email'])
    @sent_on = Time.now
    @subject = subject
    @recipients = to.respond_to?(:email) ? to.email : to
    @from = from.respond_to?(:email) ? from.email : from
    @content_type = "text/html"
  end
  
  def welcome(account)
    setup_email(account.admin, "Welcome to #{AppConfig['app_name']}!")
    @body = { :account => account }
  end
  
  def trial_expiring(user, subscription)
    setup_email(user, 'Trial period expiring')
    @body = { :user => user, :subscription => subscription }
  end
  
  def charge_receipt(subscription_payment)
    setup_email(subscription_payment.subscription.account.admin, "Your #{AppConfig['app_name']} invoice")
    @body = { :subscription => subscription_payment.subscription, :amount => subscription_payment.amount }
  end
  
  def setup_receipt(subscription_payment)
    setup_email(subscription_payment.subscription.account.admin, "Your #{AppConfig['app_name']} invoice")
    @body = { :subscription => subscription_payment.subscription, :amount => subscription_payment.amount }
  end
  
  def charge_failure(subscription)
    setup_email(subscription.account.admin, "Your #{AppConfig['app_name']} renewal failed")
    @bcc = AppConfig['from_email']
    @body = { :subscription => subscription }    
  end
  
  def plan_changed(subscription)
    setup_email(subscription.account.admin, "Your #{AppConfig['app_name']} plan has been changed")
    @body = { :subscription => subscription }    
  end
  
  def password_reset(user)
    setup_email(user, 'Password Reset Request')
    @body = { :edit_password_reset_url => edit_password_reset_url(user.perishable_token) }
  end
end

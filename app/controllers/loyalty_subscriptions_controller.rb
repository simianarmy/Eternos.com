# For last-ditch effort to get paying accounts
class LoyaltySubscriptionsController < ApplicationController
  layout 'public_notabs'
  ssl_required :all
  TESTING = true
  
  def upgrade
    @user = current_user || User.find(:first, :conditions => ["MD5(persistence_token) = ?", params[:pt]])
    if @user
      @obj = @account = @user.account
      load_subscription
      load_billing
      flash[:notice] = "Welcome back, #{@user.full_name}"
      render :action => 'billing'
    else
      render :action => 'no_user'
    end
  rescue Exception => e
    notify_about_exception(e)
    redirect_to root_url 
  end
  
  def billing  
    if request.post? || request.put?
      @user = User.find(params[:user_id])
      @obj = @account = @user.account
      load_subscription
      load_billing        
      #       @account.address = @subscription_address
      #       @account.creditcard = @creditcard
      @subscription_address.first_name = @creditcard.first_name
      @subscription_address.last_name = @creditcard.last_name
      
      if @creditcard.valid? & @subscription_address.valid?
        if @subscription.store_card(@creditcard, :billing_address => @subscription_address.to_activemerchant, :ip => request.remote_ip)
          login_and_email
          render :action => :thanks
        else
          flash[:error] = "There was an error processing your card.  Please make sure the information entered is correct and try again."
          Rails.logger.warn "*** Unable to store card!"
          Rails.logger.debug @subscription.errors.full_messages.to_s
        end
      else
        Rails.logger.debug "Credit card info not accepted"
        Rails.logger.debug @creditcard.errors.full_messages.to_s
        Rails.logger.debug @subscription_address.errors.full_messages.to_s
      end
    end
  rescue Exception => e
    notify_about_exception(e)
  end
  
  private
  
  # From AccountsController
  
  def load_billing
    @creditcard = ActiveMerchant::Billing::CreditCard.new(params[:active_merchant_billing_credit_card])
    @subscription_address = SubscriptionAddress.new(params[:subscription_address])
    @subscription_address.country ||= Country.find_by_alpha_2_code('US').id
    # Required to display proper value on submit
    @subscription_address.country = @subscription_address.country.to_i
  end
  
  def load_subscription
    @subscription = @account.subscription
    # Make sure we set current plan to paid
    @plan = SubscriptionPlan.find_by_name('Premium')
    if @subscription.subscription_plan.nil? || (@subscription.subscription_plan.name != @plan.name)
      @subscription.subscription_plan = @plan
      @subscription.save
    end
    # Fix these if already exist
    if @subscription.amount != @plan.amount
      @subscription.amount = @plan.amount
      @subscription.save
    end
  end
  
  def login_and_email
    # If all went well, send activation email & log them in
    # Make sure to forget this account in case user returns to signup pages!
    session[:account_id] = nil
    #send_activation_mail
    @user.make_member! unless @user.member?
    session_scoped_by_site do
      UserSession.create(@user, true)
    end
  end
  
  def send_activation_mail
    # Send welcome email
    UserMailer.deliver_activation(@account.admin, member_home_url)
  end
end

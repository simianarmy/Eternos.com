# Code copied from AccountsController 

class Vault::Accounts::RegistrationController < ApplicationController
  include ModelControllerMethods

  require_role "Member", :except => [:new, :create, :choose_plan, :billing, :plans, :thanks]

  before_filter :build_user, :only => [:new, :create]
  before_filter :build_plan, :only => [:new, :create]
  before_filter :load_billing, :only => [ :new, :create, :choose_plan, :billing, :paypal]
  before_filter :load_subscription, :only => [ :billing, :plan, :choose_plan, :paypal, :plan_paypal, :thanks]
  before_filter :load_discount, :only => [ :plans, :plan, :new, :create]
  before_filter :load_object, :only => [:billing, :choose_plan, :plan, :plans, :thanks]
  before_filter :check_logged_in, :only => [:new, :create]
  
  ssl_required :all
  #ssl_required :billing, :cancel, :new, :create, :plans
  #ssl_allowed :thanks, :canceled, :paypal

  layout 'vault/public/home'
  
  def new
    # Send them to plans page if they already signed up but didn't complete setup
    unless params[:force] || @account.new_record? || @user.new_record?
      redirect_to(url_for(:action => :plans)) and return false
    end
    
    session[:account_id] = nil
    @terms_of_service = true
    
    if params[:invitation_token]
      @invitation_token = params[:invitation_token]
    end
    
  end

  # 1 or 2-step process
  # For Free plans, save login info and done
  # For paying plans, 
  #   save login info
  #   save payment info

  def create
    @site_id = Account::Site.id_from_subdomain(current_subdomain)  # mark as belonging to *Vault
    @account.affiliate = SubscriptionAffiliate.find_by_token(cookies[:affiliate]) unless cookies[:affiliate].blank?
    @account.site_id = @user.site_id = @site_id
    
    # Taken from users controller to support email activation
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session

    # Using email registration?
    @user.registration_required = false
    
    # Some subscriptions use Captcha in signup form
    @hide_errors = params[:hide_errors]

    @account.user ||= @user
    @account.name = @user.full_name
    
    # Do custom validation of account fields
    
    if @account.company_name.blank?
      @account.errors.add(:company_name, "Please enter your company name")
    end
    if @account.phone_number.blank?
      @account.errors.add(:phone_number, "Please enter a contact phone number")
    end
    
    Rails.logger.debug "Creating account #{@account.inspect}"
    Rails.logger.debug "Account user #{@account.user.inspect}"
    Rails.logger.debug "Profile: #{@user.profile.inspect}"
    
    @success = false
    begin
      Account.transaction do
        @user.profile ||= Profile.new
        @account.save!
        @success = true
      end
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "There are errors in your input.  Please correct them and try again"
      Rails.logger.error "#{e.class} #{e.message}"
    rescue Exception => e
      Rails.logger.error "#{e.class} #{e.message}"      
    end
    
    if @success
      @user.register!
      @user.activate!
      
      # Set session for choose_plan
      session[:account_id] = @account.id
      redirect_to url_for(:action => :plans)
    else # @account not saved
      # Need to reload it otherwise form action will be update!?
      # Happens on transaction ROLLBACK
      unless @account.new_record?
        @account = Account.new(params[:account])
        if @account.users.any?
          @user = @account.users.first
        else
          @account.user = @user = @account.users.build
        end
      end
      @terms_of_service = @user.terms_of_service == "1"
      @invitation_token = params[:invitation_token] rescue nil
      render :action => :new
    end
  end
    
  def show
    return redirect_to(account_setup_path)
  end

  def choose_plan
    flash[:notice] = 'Your account details have been saved.'
    if @account.needs_payment_info?
      # display billing page
      @subscription = @account.subscription
      
      # Save account id for next action's load_subscription()
      session[:account_id] = @account.id
      
      render :action => 'billing'
    else
      session[:account_id] = nil
      session_scoped_by_site do
        UserSession.create(@account.admin, true)
      end
      redirect_to(account_setup_path) and return false
    end
  end

  def plans
    @plans = SubscriptionPlan.find(:all, :order => 'amount desc').collect {|p| p.discount = @discount; p }
    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
  end

  def billing  
    if request.post? || request.put?
      @plan = @subscription.subscription_plan
      if params[:paypal].blank?
        
        #       @subscription_address.first_name = @creditcard.first_name
        #       @subscription_address.last_name = @creditcard.last_name
        #       @account.address = @subscription_address
        #       @account.creditcard = @creditcard
        
        @subscription_address.first_name = @creditcard.first_name
        @subscription_address.last_name = @creditcard.last_name

        if @creditcard.valid? & @subscription_address.valid?
          if @subscription.store_card(@creditcard, :billing_address => @subscription_address.to_activemerchant, :ip => request.remote_ip)
            login_and_email
            render :action => :thanks
          end
        end
      else
        if redirect_url = @subscription.start_paypal(paypal_account_url, billing_account_url)
          redirect_to redirect_url
        end
      end
    end
  end

  # Handle the redirect return from PayPal
  def paypal
    if params[:token]
      if @subscription.complete_paypal(params[:token])
        login_and_email
        render :action => :thanks
      else
        render :action => 'billing'
      end
    else
      redirect_to :action => "billing"
    end
  end

  def thanks
    
  end

  protected
  
  def load_object
    @obj = @account = current_account
    # Force login if account cannot be found or if account has already paid..phew!
    redirect_to vlogin_path unless @obj
  end

  def build_user
    if session[:account_id]
      @account = Account.find_by_id(session[:account_id])
      Rails.logger.debug "Got account from session id: #{@account.inspect}"
      # If force option set and there is a session set, delete the temp account associated 
      # with the session
      if @account && params[:force]
        flash[:notice] = "Deleted temporary account for #{@account.admin.email}"
        @account.destroy
        @account = nil
      end
    end
    @account ||= Account.new(params[:account])
    
    # Accounts have users & user attribute..confusing! Build and/or fetch 1st user
    if @account.users.any?
      @user = @account.users.first
    else
      @account.user = @user = @account.users.build
    end
  end

  def build_plan
    unless @plan = SubscriptionPlan.find_by_name(params[:plan])
      @plan = SubscriptionPlan.find_by_name(AppConfig.default_plan)
    end
    @plan.discount = load_discount
    @account.plan = @plan
  end

  def load_billing
    @creditcard = ActiveMerchant::Billing::CreditCard.new(params[:active_merchant_billing_credit_card])
    @subscription_address = SubscriptionAddress.new(params[:subscription_address])
    @subscription_address.country ||= Country.find_by_alpha_2_code('US').id
  end

  def load_subscription
    @subscription = current_account.subscription
    @plan = @subscription.subscription_plan
    # Choosing plan comes after create action.  We already saved a default plan 
    # to the account's subscription, but they may have choosed a different one
    if params[:plan] && (params[:plan] != @plan.name) && (plan = SubscriptionPlan.find_by_name(params[:plan]))
      @plan = @subscription.subscription_plan = plan
      @subscription.save
    end
  end

  # Load the discount by code, but not if it's not available
  def load_discount
    unless @discount
      if params[:discount].blank? || !(@discount = SubscriptionDiscount.find_by_code(params[:discount])) || !@discount.available?
        @discount = nil
      end
    end
    @discount
  end

  # This never gets called by AuthenticatedSystem...why not?
  def authorized?
    %w(new create plans canceled thanks).include?(self.action_name) || 
    ((self.action_name == 'dashboard') && current_user) ||
    admin?
  end 

  # Override application_controller.rb current_account to handle newly created account
  # which has not been activated or logged in yet
  def current_account
    begin
      super
    rescue ActiveRecord::RecordNotFound
      # Could be in 2nd step of account signup where account saved but not active
      # Will raise error if no session id or account not found
      Account.find_by_id(session[:account_id])
    end
  end

  def admin_user_pending?
    (@user = @subscription.account.admin).pending?
  end

  def check_logged_in      
    if current_user
      @user = current_user
      @account = @user.account
      if current_user.setup_step == 0
        redirect_to account_setup_path
      else
        redirect_to vault_dashboard_path
      end
    end
  end
  
  def login_and_email
    # If all went well, send activation email & log them in
    # Make sure to forget this account in case user returns to signup pages!
    session[:account_id] = nil
    send_activation_mail
    session_scoped_by_site do
      UserSession.create(@account.admin, true)
    end
  end
  
  def send_activation_mail
    # Send welcome email
    Vault::UserMailer.deliver_activation(@account.admin, vault_dashboard_url)
  end
end
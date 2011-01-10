# Code copied from AccountsController 

class Vault::AccountsController < ApplicationController
  include ModelControllerMethods

  require_role "Member", :except => [:new, :create, :billing, :plans, :canceled, :thanks]
  permit "admin for :account", :only => [:edit, :update, :plan, :cancel, :dashboard]

  before_filter :build_user, :only => [:new, :create]
  before_filter :build_plan, :only => [:new, :create]
  before_filter :load_billing, :only => [ :new, :create, :billing, :paypal]
  before_filter :load_subscription, :only => [ :show, :edit, :billing, :plan, :paypal, :plan_paypal, :update]
  before_filter :load_discount, :only => [ :plans, :plan, :new, :create]
  before_filter :load_object, :only => [:show, :edit, :billing, :plan, :cancel, :update]
  before_filter :require_no_user, :only => [:new, :create, :canceled]
  
  #ssl_required :billing, :cancel, :new, :create, :plans
  #ssl_allowed :thanks, :canceled, :paypal

  def new
    @terms_accepted = true
    
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
    @account.affiliate = SubscriptionAffiliate.find_by_token(cookies[:affiliate]) unless cookies[:affiliate].blank?

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

    @success = using_captcha_in_signup?(@account) ? verify_recaptcha(:model => @account) : true
    @account.name = @user.full_name
    
    Rails.logger.debug "Creating account #{@account.inspect}"
    Rails.logger.debug "Account user #{@account.user.inspect}"
    Rails.logger.debug "Profile: #{@user.profile.inspect}"
    
    if @success && @account.save && @user.profile.save
      Rails.logger.debug "Profile: #{@user.profile.inspect}"
      @user.register!
      @user.activate!
      # Save account id for next action's load_subscription()
      session[:account_id] = @account.id
    else # @account not saved
      @terms_accepted = @user.terms_of_service == "1"
      @invitation_token = params[:user][:invitation_token] rescue nil
      render :action => :new
    end
  end
    
  def show
    return redirect_to(member_home_path)
    #@plan = @subscription.subscription_plan
  end

  def edit
    @user = @account.admin
    @plan = @subscription.subscription_plan
  end

  def choose_plan
    if @account.needs_payment_info?
      # display billing page
      @subscription = @account.subscription
      flash[:domain] = @account.domain
      # Save account id for next action's load_subscription()
      session[:account_id] = @account.id
      render :action => 'billing'
    end
  end
  
  def update
    @user = @account.admin
    @plan = @subscription.subscription_plan

    if @user.update_attributes(params[:account][:user])
      flash_redirect "Your account has been updated.", edit_account_path
    else
      render :action => 'edit'
    end
  end

  def plans
    @plans = SubscriptionPlan.find(:all, :order => 'amount desc').collect {|p| p.discount = @discount; p }
    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
  end

  def billing  
    @user = current_user
    if request.post?
      @plan = @subscription.subscription_plan
      if params[:paypal].blank?
        
        #       @address.first_name = @creditcard.first_name
        #       @address.last_name = @creditcard.last_name
        #       @account.address = @address
        #       @account.creditcard = @creditcard
        
        @address.first_name = @creditcard.first_name
        @address.last_name = @creditcard.last_name

        if @creditcard.valid? & @address.valid?
          if @subscription.store_card(@creditcard, :billing_address => @address.to_activemerchant, :ip => request.remote_ip)
            if admin_user_pending?
              activate_and_redirect_to account_setup_url
            else
              flash[:notice] = "Your billing information has been updated."
              redirect_to :action => "billing"
            end
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
        if admin_user_pending?
          redirect_to activate_path(@user.activation_code)
        else
          flash[:notice] = 'Your billing information has been updated'
          redirect_to :action => "billing"
        end
      else
        render :action => 'billing'
      end
    else
      redirect_to :action => "billing"
    end
  end

  def plan
    if request.post?
      @subscription.plan = SubscriptionPlan.find(params[:plan_id])

      # PayPal subscriptions must get redirected to PayPal when
      # changing the plan because a new recurring profile needs
      # to be set up with the new charge amount.
      if @subscription.paypal?
        # Purge the existing payment profile if the selected plan is free
        if @subscription.amount == 0
          logger.info "FREE"
          if @subscription.purge_paypal
            logger.info "PAYPAL"
            flash[:notice] = "Your subscription has been changed."
            SubscriptionNotifier.deliver_plan_changed(@subscription)
          else
            flash[:error] = "Error deleting PayPal profile: #{@subscription.errors.full_messages.to_sentence}"
          end
          redirect_to :action => "plan" and return
        else
          if redirect_url = @subscription.start_paypal(plan_paypal_account_url(:plan_id => params[:plan_id]), plan_account_url)
            redirect_to redirect_url and return
          else
            flash[:error] = @subscription.errors.full_messages.to_sentence
            redirect_to :action => "plan" and return
          end
        end
      end

      if @subscription.save
        flash[:notice] = "Your subscription has been changed."
        SubscriptionNotifier.deliver_plan_changed(@subscription)
      else
        flash[:error] = "Error updating your plan: #{@subscription.errors.full_messages.to_sentence}"
      end
      redirect_to :action => "plan"
    else
      @plans = SubscriptionPlan.find(:all, :conditions => ['id <> ?', @subscription.subscription_plan_id], :order => 'amount desc').collect {|p| p.discount = @subscription.discount; p }
    end
  end

  # Handle the redirect return from PayPal when changing plans
  def plan_paypal
    if params[:token]
      @subscription.plan = SubscriptionPlan.find(params[:plan_id])
      if @subscription.complete_paypal(params[:token])
        flash[:notice] = "Your subscription has been changed."
        SubscriptionNotifier.deliver_plan_changed(@subscription)
        redirect_to :action => "plan"
      else
        flash[:error] = "Error completing PayPal profile: #{@subscription.errors.full_messages.to_sentence}"
        redirect_to :action => "plan"
      end
    else
      redirect_to :action => "plan"
    end
  end


  def cancel
    if request.post? and !params[:confirm].blank?
      current_account.cancel
      current_user_session.destroy
      self.current_user = nil
      redirect_to :action => "canceled"
    end
  end

  def thanks
    redirect_to :action => "plans" and return unless flash[:domain]
    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
  end

  def dashboard
    render :text => 'Dashboard action, engage!', :layout => true
  end

  protected

  def load_object
    @obj = @account = current_account
  end

  def build_user
    @account ||= Account.new(params[:account])
    @account.user = @user = User.new(params[:user])
    pattrs = params[:user][:profile] rescue {}
    @user.build_profile(pattrs)
  end

  def build_plan
    unless @plan = SubscriptionPlan.find_by_name(params[:plan])
      @plan = SubscriptionPlan.find_by_name(AppConfig.default_plan)
    end
    @plan.discount = load_discount
    @account.plan = @plan
    @use_captcha = using_captcha_in_signup?(@account)
  end

  def redirect_url
    { :action => 'show' }
  end

  def load_billing
    @creditcard = ActiveMerchant::Billing::CreditCard.new(params[:creditcard])
    @address = SubscriptionAddress.new(params[:address])
  end

  def load_subscription
    @subscription = current_account.subscription
    @plan = @subscription.subscription_plan
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

  def activate_and_redirect_to(redirect_path)
    @user.activate! # unless @user.email_registration_required?
    flash_redirect "Your account has been created.", redirect_path
  end

  # Override application_controller.rb current_account to handle newly created account
  # which has not been activated or logged in yet
  def current_account
    begin
      super
    rescue ActiveRecord::RecordNotFound
      # Could be in 2nd step of account signup where account saved but not active
      # Will raise error if no session id or account not found
      Account.find(session[:account_id]) 
    end
  end

  def admin_user_pending?
    (@user = @subscription.account.admin).pending?
  end

  def check_logged_in      
    redirect_to member_home_url if current_user
  end

  def using_captcha_in_signup?(account)
    true
  end
end
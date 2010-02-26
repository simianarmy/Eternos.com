class AccountsController < ApplicationController
  include ModelControllerMethods
  
  require_role "Member", :except => [:new, :create, :billing, :plans, :canceled, :thanks]
  permit "admin for :account", :only => [:edit, :update, :plan, :cancel, :dashboard]
  
  before_filter :set_facebook_connect_session
  before_filter :build_user, :only => [:new, :create]
  before_filter :build_plan, :only => [:new, :create]
  before_filter :load_billing, :only => [ :new, :create, :billing, :paypal]
  before_filter :load_subscription, :only => [ :show, :edit, :billing, :plan, :paypal, :plan_paypal, :update]
  before_filter :load_discount, :only => [ :plans, :plan, :new, :create ]
  before_filter :load_object, :only => [:show, :edit, :billing, :plan, :cancel, :update]
  
  before_filter :require_no_user, :only => [:new, :create, :canceled]
  # Need more fine-grained control than redirect for all actions
  #before_filter :check_logged_in
  
  ssl_required :billing, :cancel, :new, :create, :plans
  ssl_allowed :thanks, :canceled, :paypal
  
  def new
    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
    @terms_accepted = true
    if params[:invitation_token]
      @invitation_token = params[:invitation_token]
    end
    # If here from main page fb connect, load fb-related data
    begin
      if facebook_session && (fbuser = facebook_session.user) && (prof = FacebookUserProfile.populate(fbuser))
        @user[:first_name] = prof[:first_name]
        @user[:last_name] = prof[:last_name]
        @user.facebook_id = fbuser.uid
      end
    rescue
      # Nothing to say..
    end
  end

  # 1 or 2-step process
  # For Free plans, save login info and done
  # For paying plans, 
  #   save login info
  #   save payment info
  
  def create
    # If this user has already registered via facebook, redirect to member page
    if params[:user] && params[:user][:facebook_id] && !params[:user][:facebook_id].blank?
      if User.find_by_facebook_uid(params[:user][:facebook_id])
        # Login manually & redirect to member home
        UserSession.create
        redirect_to member_home_url
        return
      end
    end
    @account.affiliate = SubscriptionAffiliate.find_by_token(cookies[:affiliate]) unless cookies[:affiliate].blank?
    
    # Taken from users controller to support email activation
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    
    # Don't use email activation for paying accounts
    @user.registration_required = false if @account.needs_payment_info?
    
    # if @account.needs_payment_info?
    #       @address.first_name = @creditcard.first_name
    #       @address.last_name = @creditcard.last_name
    #       @account.address = @address
    #       @account.creditcard = @creditcard
    #     end
    
    # Free subscriptions use Captcha in signup form
    @success = @plan.free? ? verify_recaptcha(:model => @account) : true
    @account.name = @user.full_name
    
    if @success && @account.save
      @user.register!
      
      if @account.needs_payment_info?
        @subscription = @account.subscription
        flash[:domain] = @account.domain
        # Save account id for next action's load_subscription()
        session[:account_id] = @account.id
        render :action => 'billing'
      else
        activate_and_redirect_to account_setup_url
      end
    else
      @terms_accepted = true unless params[:user][:terms_of_service] == "0"
      @invitation_token = params[:user][:invitation_token]
      
      render :action => 'new'#:layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
    end
  end
  
  def show
    #return redirect_to(member_home_path)
    @plan = @subscription.subscription_plan
  end
  
  def edit
    @user = @account.admin
    @plan = @subscription.subscription_plan
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
      @account.user = @user = User.new(params[:user])
    end
    
    def build_plan
      return redirect_to root_url unless plan = params[:plan]
      redirect_to :action => "plans" unless @account.plan = @plan = SubscriptionPlan.find_by_name(plan)
      @plan.discount = @discount
      @account.plan = @plan
      @use_captcha = @plan.free? && AppConfig.email_registration_required
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
      if params[:discount].blank? || !(@discount = SubscriptionDiscount.find_by_code(params[:discount])) || !@discount.available?
        @discount = nil
      end
    end
    
    # This never gets called by AuthenticatedSystem...why not?
    def authorized?
      %w(new create plans canceled thanks).include?(self.action_name) || 
      ((self.action_name == 'dashboard') && current_user) ||
      admin?
    end 
    
    def activate_and_redirect_to(redirect_path)
      @user.activate! unless @user.email_registration_required?
      flash_redirect "Your account has been created.", redirect_path
    end
    
    # Override Application.rb current_account to handle newly created account
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

end

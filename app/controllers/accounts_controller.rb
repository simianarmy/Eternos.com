class AccountsController < ApplicationController
  include ModelControllerMethods
  require_role "Member", :except => [:new, :create, :plans, :canceled, :thanks]
  permit "admin for :account", :only => [:edit, :update, :plan, :billing, :cancel, :dashboard]
   
  before_filter :set_facebook_session 
  before_filter :build_user, :only => [:new, :create]
  before_filter :build_plan, :only => [:new, :create]
  before_filter :load_billing, :only => [ :new, :create, :billing, :paypal]
  before_filter :load_subscription, :only => [ :show, :edit, :billing, :plan, :paypal, :update]
  before_filter :load_object, :only => [:show, :edit, :billing, :plan, :cancel, :update]
  
  #ssl_required :billing, :cancel, :new, :create, :plans
  #ssl_allowed :thanks, :canceled, :paypal
  
  def new
    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
  end

  # 1 or 2-step process
  # For Free plans, save login info and done
  # For paying plans, 
  #   save login info
  #   save payment info
  
  def create
    # If this user has already registered via facebook, redirect to member page
    if params[:user][:facebook_id]
      if User.find_by_facebook_uid(params[:user][:facebook_id])
        # Login manually & redirect to member home
        UserSession.create
        redirect_to member_home_path
        return
      end
    end
    
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
    
    if verify_recaptcha(:model => @account) and @account.save
      @user.register!
      @user.activate! unless @user.email_registration_required?
      
      if @account.needs_payment_info?
        @subscription = @account.subscription
        flash[:domain] = @account.domain
        # Save account id for next action's load_subscription()
        session[:account_id] = @account.id
        render :action => 'billing'
      else
        flash_redirect "Account created!", member_home_path
        #rennder :action => 'thanks', :layout => false
      end
    else
      @checked = true
      render :action => 'new'#:layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
    end
  end
  
  def show
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
    @plans = SubscriptionPlan.find(:all, :order => 'amount desc')

    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
  end
  
  def billing  
    if request.post?
      @plan = @subscription.subscription_plan
      if params[:paypal].blank?
        if @creditcard.valid? & @address.valid?
          @address.first_name = @creditcard.first_name
          @address.last_name = @creditcard.last_name
          if @subscription.store_card(@creditcard, :billing_address => @address.to_activemerchant, :ip => request.remote_ip)
            if admin_user_pending?
              redirect_to activate_path(@user.activation_code)
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
      @old_plan = @subscription.subscription_plan
      @plan = SubscriptionPlan.find(params[:plan_id])
      if @subscription.update_attributes(:plan => @plan)
        flash[:notice] = "Your subscription has been changed."
        spawn do
          SubscriptionNotifier.deliver_plan_changed(@subscription)
        end
        redirect_to :action => "plan"
      else
        @subscription.plan = @old_plan
      end
    end
  end

  def cancel
    if request.post? and !params[:confirm].blank?
      current_account.destroy
      self.current_user = nil
      reset_session
      redirect_to :action => "canceled"
    end
  end
  
  def thanks
    #redirect_to :action => "plans" and return unless flash[:domain]
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
      redirect_to :action => "plans" unless @account.plan = @plan = SubscriptionPlan.find_by_name(params[:plan])
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
    
    # This never gets called by AuthenticatedSystem...why not?
    def authorized?
      %w(new create plans canceled thanks).include?(self.action_name) || 
      ((self.action_name == 'dashboard') && current_user) ||
      admin?
    end 
    
  private

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
    
end

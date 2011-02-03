# Code copied from AccountsController 

class Vault::Accounts::ManagerController < ApplicationController
  include ModelControllerMethods

  require_role "Member", :except => [:billing, :plans, :canceled, :thanks]
  permit "admin for :account", :only => [:edit, :change_password, :update, :plan, :plans, :cancel, :dashboard]

  before_filter :load_billing, :only => [:billing, :paypal]
  before_filter :load_subscription, :only => [ :show, :edit, :billing, :plan, :plans, :paypal, :plan_paypal, :update, :change_password]
  before_filter :load_discount, :only => [ :plans, :plan, :plans]
  before_filter :load_object, :only => [:show, :edit, :billing, :plan, :plans, :cancel, :update, :change_password]
  before_filter :check_logged_in, :only => [:canceled]
  
  #ssl_required :billing, :cancel, :new, :create, :plans
  #ssl_allowed :thanks, :canceled, :paypal

  layout :set_layout
    
  def show
    #@plan = @subscription.subscription_plan
  end

  def edit
    @user = @account.admin
    @plan = @subscription.subscription_plan
    render :layout => 'vault/private/billing'
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

    # We must manually update associated user
    if @account.update_attributes(params[:account]) &&
      @user.update_attributes(params[:account]['users_attributes']['0'])
      flash[:notice] = "Your account has been updated."
    end
    
    render :action => 'show'
  end

  def change_password
    @user = @account.admin
    # Check for password update form
    pwd = params[:account]['users_attributes']['0']['password']
    if pwd
      pwd.strip!
      if pwd.blank?
        flash[:error] = "Password cannot be empty"
      elsif pwd == params[:account]['users_attributes']['0']['password_confirmation']
        @user.password = @user.password_confirmation = pwd
        Rails.logger.debug "Saving new password " + pwd

        if @user.save
          flash[:notice] = "Your password has been updated."
        else
          flash[:error] = "There was an error updating your password"
        end
      else
        flash[:error] = "Passwords do not match"
      end
    end
    render :action => 'show'
  end
  
  def plans
    @plans = SubscriptionPlan.find(:all, :order => 'amount desc').collect {|p| p.discount = @discount; p }
    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
    render :layout => 'vault/private/billing'
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

  def set_layout
    'vault/private/account'
  end
  
  def load_object
    @obj = @account = current_account
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
    if current_user
      if current_user.setup_step == 0
        redirect_to account_setup_path 
      else
        redirect_to vault_dashboard_path
      end
    end
  end

end
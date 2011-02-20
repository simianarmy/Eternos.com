class SubscriptionAdmin::AccountsController < AdminsController
  include ModelControllerMethods
  include AdminControllerMethods
  
  def index
    @accounts = Account.paginate(:include => :subscription, :page => params[:page], :per_page => 30, :order => 'accounts.name')
  end
  
end

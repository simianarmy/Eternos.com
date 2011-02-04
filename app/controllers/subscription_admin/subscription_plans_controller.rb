class SubscriptionAdmin::SubscriptionPlansController < AdminsController
  include ModelControllerMethods
  include AdminControllerMethods
  
  protected
  
    def load_object
      @obj = @subscription_plan = SubscriptionPlan.find_by_name(params[:id])
    end
end

# $Id$

module SubscriptionsHelper
  def site_account_plan(plan)
    AppConfig.app_name + " - " + plan.to_param
  end
  
  def change_plan_button_text(current_plan, button_plan)
    if button_plan.amount > current_plan.amount
      'Upgrade'
    elsif button_plan.amount < current_plan.amount
      'Downgrade'
    elsif button_plan == current_plan
      'Your plan'
    else
      'Select'
    end
  end
end
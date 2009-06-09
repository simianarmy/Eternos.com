# $Id$

module SubscriptionsHelper
  def site_account_plan(plan)
    AppConfig.app_name + " - " + plan.to_param
  end
end
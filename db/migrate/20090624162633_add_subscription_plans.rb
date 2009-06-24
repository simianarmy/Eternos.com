class AddSubscriptionPlans < ActiveRecord::Migration
  def self.up
    SubscriptionPlan.create(:name => 'Free', :user_limit => 2, :renewal_period => 1)
    SubscriptionPlan.create(:name => 'Basic', :user_limit => 5, :renewal_period => 1)
    SubscriptionPlan.create(:name => 'Premium', :renewal_period => 1)
  end

  def self.down
    SubscriptionPlan.destroy_all
  end
end

class SubscriptionPlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  # renewal_period is the number of months to bill at a time
  # default is 1
  validates_numericality_of :renewal_period, :only_integer => true, :greater_than => 0

  def to_s
    "#{self.name} - #{number_to_currency(self.amount)} / month"
  end
  
  def to_param
    self.name
  end

  def free?
    amount.nil? or (amount == 0)
  end
end

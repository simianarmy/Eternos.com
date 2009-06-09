class SubscriptionPayment < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :account
  
  before_create :set_account
  after_create :send_receipt
  
  def set_account
    self.account = subscription.account
  end
  
  def send_receipt
    return unless amount > 0
    spawn do
      if setup?
        SubscriptionNotifier.deliver_setup_receipt(self)
      else
        SubscriptionNotifier.deliver_charge_receipt(self)
      end
    end
    true
  end
end

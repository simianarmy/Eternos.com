class CreateSaasTables < ActiveRecord::Migration
  def self.up
    create_table "password_resets", :force => true do |t|
      t.string   "email"
      t.integer  "user_id",    :limit => 11
      t.string   "remote_ip"
      t.string   "token"
      t.datetime "created_at"
    end

    create_table "subscription_discounts", :force => true do |t|
      t.string   "name"
      t.string   "code"
      t.decimal  "amount",     :precision => 6, :scale => 2, :default => 0.0
      t.boolean  "percent"
      t.date     "start_on"
      t.date     "end_on"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "subscription_plans", :force => true do |t|
      t.string   "name"
      t.decimal  "amount",                       :precision => 10, :scale => 2
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_limit",     :limit => 11
      t.integer  "renewal_period", :limit => 11,                                :default => 1
      t.decimal  "setup_amount",                 :precision => 10, :scale => 2
      t.integer  "trial_period",   :limit => 11,                                :default => 1
    end
    
    create_table "accounts", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "full_domain"
      t.datetime "deleted_at"
      t.integer  "subscription_discount_id", :limit => 11
    end

    create_table "subscriptions", :force => true do |t|
      t.decimal  "amount",                             :precision => 10, :scale => 2
      t.datetime "next_renewal_at"
      t.string   "card_number"
      t.string   "card_expiration"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "state",                                                             :default => "trial"
      t.integer  "subscription_plan_id", :limit => 11, :references => nil
      t.integer  "account_id",           :limit => 11
      t.integer  "user_limit",           :limit => 11, :references => nil
      t.integer  "renewal_period",       :limit => 11, :default => 1, :references => nil
      t.string   "billing_id",  :references => nil
    end
    
    create_table "subscription_payments", :force => true do |t|
      t.integer  "account_id",      :limit => 11
      t.integer  "subscription_id", :limit => 11
      t.decimal  "amount",                        :precision => 10, :scale => 2, :default => 0.0
      t.string   "transaction_id", :references => nil
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "setup"
    end
    
    change_table :users do |t|
      t.string :name
      t.integer :account_id, :limit => 11
    end
    
  end

  def self.down
    drop_table "password_resets" 
    drop_table  "subscription_discounts" 
    drop_table "subscription_plans"
    drop_table    "accounts"   
    drop_table    "subscriptions"   
    drop_table    "subscription_payments"
    
    change_table :users do |t|
      t.remove :name, :account_id
    end
  end
end

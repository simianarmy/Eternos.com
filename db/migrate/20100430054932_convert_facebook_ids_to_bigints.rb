class ConvertFacebookIdsToBigints < ActiveRecord::Migration
  def self.up
    execute("alter table users modify facebook_uid bigint")
    execute("alter table users modify facebook_referrer bigint")
  end

  def self.down
    execute("alter table users modify facebook_uid integer")
    execute("alter table users modify facebook_referrer integer")
  end
end

class DevStagingMap < ActiveRecord::Base
  
  def env
    (self.environment ? self.environment : 'staging')
  end
  
  def mapped_id
    (env == 'staging') ? staging_user_id : production_user_id
  end
end

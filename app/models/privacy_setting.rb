# $Id$
class PrivacySetting < ActiveRecord::Base
  belongs_to :authorizable, :polymorphic => true
  belongs_to :user
  
  # access permissions as bit vector
  composed_of :permissions
  
  validates_presence_of :authorizable_id, :authorizable_type
  validate :presence_of_user_or_circle
  
  def settings
    permissions.permissions
  end
  
  def presence_of_user_or_circle
    unless user_id or circle_id
      errors.add_to_base "User or Circle id required"
    end
  end
end

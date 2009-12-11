# $Id$

class ContentAccessor < ActiveRecord::Base
  belongs_to :content_authorization
  belongs_to :user
  belongs_to :circle
  
  # access permissions as bit vector
  composed_of :permissions
  
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

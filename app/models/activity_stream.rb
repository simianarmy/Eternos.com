# $Id$

class ActivityStream < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  has_many :items, :class_name => 'ActivityStreamItem'
  
end

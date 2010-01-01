# $Id$

class School < ActiveRecord::Base
  belongs_to :profile
  belongs_to :country
  has_one :member, :through => :profile
  
  acts_as_archivable :on => :start_at
  acts_as_taggable
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  validates_presence_of :name, :message => "Please enter a school name"

  include TimelineEvents
  include CommonDateScopes
  include CommonDurationScopes
  
  # thinking_sphinx
  define_index do
    indexes :name
    indexes degree
    indexes fields
    indexes activities_societies
    indexes awards
    indexes recognitions
    indexes notes
    indexes country(:name), :as => 'country'

    has profile_id, start_at, end_at
  end
end
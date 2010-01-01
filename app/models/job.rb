# $Id$

class Job < ActiveRecord::Base
  belongs_to :profile
  has_one :member, :through => :profile
  
  acts_as_archivable :on => :start_at
  acts_as_taggable
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  validates_presence_of :company, :message => "Please enter a company name"
  validates_presence_of :title, :message => "Please enter a job title"
  
  include TimelineEvents
  include CommonDateScopes
  include CommonDurationScopes
  
  # thinking_sphinx
  define_index do
    indexes company
    indexes title
    indexes description
    indexes notes
    
    has profile_id, start_at, end_at
  end
end
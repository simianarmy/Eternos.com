# $Id$

class Family < ActiveRecord::Base
  belongs_to :profile
  has_one :member, :through => :profile
  
  validates_presence_of :name, :message => "Please enter a name"
  validates_presence_of :family_type, :message => "Please specify a relationship"
  
  TYPES = ["Brother","Sister","Mother","Father","Aunt","Uncle","Other"]

  acts_as_archivable :on => :birthdate
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked

  alias_attribute :end_at, :died_at
  
	include TimelineEvents
	include CommonDateScopes
	include CommonDurationScopes
  self.end_archivable_attribute = :died_at
  
	# thinking_sphinx
  define_index do
    # fields
    indexes :name
    indexes family_type
    indexes notes
    
    # attributes
    has profile_id, birthdate, died_at
  end

end   

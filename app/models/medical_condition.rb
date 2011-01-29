# $Id$

class MedicalCondition < ActiveRecord::Base
  belongs_to :profile
  has_one :member, :through => :profile
  
  validates_presence_of :name, :message => "Please enter a name for the medical condition"
  
  acts_as_archivable :on => :diagnosis_date
  acts_as_taggable
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  include TimelineEvents
  include CommonDateScopes
  include CommonDurationScopes
  self.end_archivable_attribute = :treatment_end_on
  
  # thinking_sphinx
  define_index do
    indexes :name
    indexes diagnosis
    indexes treatment
    indexes notes
    
    has profile_id, diagnosis_date, treatment_start_on, treatment_end_on, created_at
  end
end

# $Id$

class MedicalCondition < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => "Please enter a name for the medical condition"
  
  acts_as_archivable :on => :diagnosis_date
  include TimelineEvents
  
  # thinking_sphinx
  define_index do
    indexes :name
    indexes diagnosis
    indexes treatment
    indexes notes
    
    has profile_id, diagnosis_date, treatment_start_on, treatment_end_on
  end
end

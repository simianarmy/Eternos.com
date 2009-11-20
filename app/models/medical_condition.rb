# $Id$

class MedicalCondition < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => "Please enter a name for the medical condition"
  
  acts_as_archivable :on => :diagnosis_date
  include TimelineEvents
end

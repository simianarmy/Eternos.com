class Family < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => "Please enter a name"
  validates_presence_of :family_type, :message => "Please specify a relationship"
  
  TYPES = ["Brother","Sister","Mother","Father","Aunt","Uncle","Other"]

  acts_as_archivable :on => :birthdate
	
	include TimelineEvents
end   

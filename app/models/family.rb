class Family < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => "Please enter a name"
  validates_presence_of :family_type, :message => "Please specify a relationship"
  
  TYPES = ["Brother","Sister","Mother","Father","Aunt","Uncle","Other"]

  acts_as_archivable :on => :birthdate
	
	include TimelineEvents
	
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

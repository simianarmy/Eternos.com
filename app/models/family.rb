class Family < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => " can't be blank"
  TYPES = ["Brother","Sister","Mother","Father","Aunt","Uncle","Other"]

  acts_as_archivable :on => :birthdate
end   

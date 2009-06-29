class Family < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => "Please enter a family name"
  TYPES = ["Brother","Sister","Mother","Father","Aunt","Uncle","Other"]

end   

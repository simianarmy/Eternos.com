class Family < ActiveRecord::Base
  belongs_to :profile
  
  TYPES = ["Brother","Sister","Mother","Father","Aunt","Uncle","Other"]

end   

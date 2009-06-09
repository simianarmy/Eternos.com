class Documentary < Story
  belongs_to :recording
  
  acts_as_decoratable
end

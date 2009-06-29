class Medical < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => "Please enter a medical name"
end

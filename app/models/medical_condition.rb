class MedicalCondition < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :name, :message => "Please enter a medical condition name"
end

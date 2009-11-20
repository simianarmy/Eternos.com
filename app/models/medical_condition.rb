class MedicalCondition < ActiveRecord::Base
  belongs_to :profile
  
  validate do |medical_condition|
    medical_condition.errors.add("", "Please enter a medical condition name") if medical_condition.name.blank?
  end
  
  include TimelineEvents
end

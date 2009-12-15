class Medical < ActiveRecord::Base
  belongs_to :profile
  
  validate do |medical|
    medical.errors.add("", "Please enter a medical name") if medical.name.blank?
  end
  
  include TimelineEvents
  
  # thinking_sphinx
  define_index do
    indexes :name
    indexes blood_type
    indexes disorder
    indexes physician_name
    indexes notes
    
    has profile_id, created_at
  end
end

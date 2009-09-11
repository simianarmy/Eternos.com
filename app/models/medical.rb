class Medical < ActiveRecord::Base
  belongs_to :profile
  
  validate do |medical|
    medical.errors.add("", "Please enter a medical name") if medical.name.blank?
  end
  
  include TimelineEvents
  serialize_with_options do
    methods :start_date
  end
end

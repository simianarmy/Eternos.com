# $Id$
class Relationship < ActiveRecord::Base
  belongs_to :profile
  belongs_to :person
  
  validates_presence_of :description, :message => "Please enter a description of the relationship"  
  
  accepts_nested_attributes_for :person
  acts_as_archivable :on => :start_at
  
  include TimelineEvents
  include CommonDateScopes
  include CommonDurationScopes
    
  # thinking_sphinx
  define_index do
    indexes :name
    indexes description
    indexes notes
    indexes person(:name), :as => :person_name
    
    has profile_id, start_at, end_at, created_at
  end
end

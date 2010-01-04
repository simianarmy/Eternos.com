# $Id$

class Job < ActiveRecord::Base
  belongs_to :profile
  has_one :member, :through => :profile
  has_one :location, :as => :addressable
  
  acts_as_archivable :on => :start_at
  acts_as_taggable
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  validates_presence_of :company, :message => "Please enter a company name"
  validates_presence_of :title, :message => "Please enter a job title"
  validates_uniqueness_of :title, :scope => [:profile_id, :company], :message => "An entry already exists with those settings"
  
  include TimelineEvents
  include CommonDateScopes
  include CommonDurationScopes
  
  # thinking_sphinx
  define_index do
    indexes company
    indexes title
    indexes description
    indexes notes
    
    has profile_id, start_at, end_at
  end
  
  def self.attributes_from_fb(workinfo)
    {:start_at => FacebookUserProfile.parse_model_date(workinfo.start_date),
      :end_at => FacebookUserProfile.parse_model_date(workinfo.end_date),
      :company => workinfo.company_name,
      :title => workinfo.position,
      :description => workinfo.description}
  end
  
  protected
  
  
end
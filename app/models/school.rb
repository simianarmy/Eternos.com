# $Id$

class School < ActiveRecord::Base
  belongs_to :profile
  belongs_to :country
  has_one :member, :through => :profile
  
  acts_as_archivable :on => :start_at
  acts_as_taggable
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  validates_presence_of :name, :message => "Please enter a school name"
  validates_uniqueness_of :name, :scope => :profile_id, :message => "An entry already exists with those settings"
  
  include TimelineEvents
  include CommonDateScopes
  include CommonDurationScopes
  
  # thinking_sphinx
  define_index do
    indexes :name
    indexes degree
    indexes fields
    indexes activities_societies
    indexes awards
    indexes recognitions
    indexes notes
    indexes country(:name), :as => 'country'

    has profile_id, start_at, end_at
  end
  
  def self.attributes_from_fb(education)
    {:name => education.name,
      :degree => education.degree,
      :fields => education.concentrations.join(','),
      :end_at => Date.strptime(education.year, '%Y')
    }
  end
end
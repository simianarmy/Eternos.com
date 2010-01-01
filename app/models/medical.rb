class Medical < ActiveRecord::Base
  belongs_to :profile
  has_one :member, :through => :profile
  
  validates_presence_of :name, :message => "Please enter a name"
  
  acts_as_archivable :on => :created_at
  acts_as_taggable
  acts_as_restricted :owner_method => :member
  acts_as_commentable
  acts_as_time_locked
  
  include TimelineEvents
  include CommonDateScopes
  
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

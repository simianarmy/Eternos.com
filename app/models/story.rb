# $Id$

class Story < ActiveRecord::Base
  has_many :elements, :dependent => :destroy, :order => :position
  has_one :theme
  belongs_to :category
  belongs_to :member, :foreign_key => 'user_id'
    
  has_attached_file :photo, :styles => {:small => "150x150>"},
    :url  => "/assets/stories/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/stories/:id/:style/:basename.:extension"
    
  acts_as_restricted :owner_method => :member
  acts_as_time_period
  acts_as_commentable
  acts_as_taggable_on :tags
  acts_as_time_locked
  acts_as_av_attachable
  acts_as_decoratable
  
  include Categorizable

  with_options :if => :story_validations_required? do |s|
    s.validates_presence_of :title, :message => "Please enter a title for your story"
    s.validates_presence_of :category, :message => "Select or enter a Category"
    #s.validates_presence_of :description, :message => "Please enter a description for your story"
  end
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  validates_as_time_period
  
  # Used for STI children validation
  def story_validations_required?
    self.instance_of? Story
  end
  
  # Class methods
  
  # Returns all stories viewable by logged in user (or specified user param)
  def self.viewable_stories(user)
    find(:all)
  end

  # Instance methods
  
  def has_photo?
    not photo_file_name.nil?
  end

  private
end

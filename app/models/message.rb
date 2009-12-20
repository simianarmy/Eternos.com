# $Id

class Message < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  belongs_to :category
  has_one :av_attachment, :as => :av_attachable, :dependent => :destroy
  
  acts_as_archivable :order => 'DESC'
  acts_as_decoratable
  acts_as_restricted :owner_method => :member
  acts_as_time_period
  acts_as_commentable
  acts_as_taggable
  acts_as_time_locked
  
  delegate :recording, :to => :av_attachment
  
  include Categorizable
  
  validates_presence_of :title, :message => "Please enter a title"
  validates_presence_of :message, :message => "Please enter a message"
  validates_as_time_period
  
  xss_terminate :except => [:message]
  
  # Class methods
  
  # Instance methods
  
end

# $Id$
#

class Memento < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  @@version = '0.1a'
  
  attr_accessor :html_slide
  serialize :slides
  serialize :soundtrack
  
  validates_presence_of :title, :message => "Please enter a title"
  validates_presence_of :slides, :message => "A Memento must contain at least one image, movie, or text slide!"
  
  before_create :set_version
  
  protected
  
  def set_version
    self.version = @@version
  end
end


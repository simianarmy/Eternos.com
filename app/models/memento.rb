# $Id$
#

class Memento < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  @@version = '0.1a'
  
  attr_accessor :html_slide
  serialize :slides
  
  before_create :set_version
  
  protected
  
  def set_version
    self.version = @@version
  end
end


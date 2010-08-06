# $Id$
#

class Memento < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  
  attr_accessor :html_slide
end


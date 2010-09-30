# $Id$

class EmailList < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  
  validates_presence_of :name
end
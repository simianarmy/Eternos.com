# $Id$

class ActivityStreamItem < ActiveRecord::Base
  belongs_to :activity_stream
  
  serialize :attachment_data
  xss_terminate :except => [ :attachment_data ]
  
  named_scope :newest, :order => "created_at DESC", :limit => 1
end

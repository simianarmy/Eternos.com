# $Id$

class FacebookContent < ActiveRecord::Base
  belongs_to :profile
  
  serialize :friends
  xss_terminate :except => [ :friends ]
end

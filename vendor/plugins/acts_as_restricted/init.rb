# Include hook code here
require File.dirname(__FILE__) + '/lib/acts_as_restricted'
require File.dirname(__FILE__) + '/lib/content_accessor'
require File.dirname(__FILE__) + '/lib/content_authorization'
require File.dirname(__FILE__) + '/lib/permissions'

ActiveRecord::Base.class_eval do
  include Eternos::Acts::Restricted
end

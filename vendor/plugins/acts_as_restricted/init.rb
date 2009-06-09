# Include hook code here
require 'acts_as_restricted'

ActiveRecord::Base.class_eval do
  include Eternos::Acts::Restricted
end

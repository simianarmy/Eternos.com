# $Id$

# Proxy classes to normalize activity stream interface methods for passing to activerecord objects.
# Child classes used by ActiveRecord classes to create/update info in a consistent way

# See facebook_activity.rb for usage example
require 'hashie'

class ActivityStreamProxy
  attr_reader :data
  
  def initialize(data={})
    @data = Hashie::Mash.new(data)
  end
  
  # TODO: For backwards compat - update client code
  def attachment_data
    attachment
  end
  
  # Assumes caller is interested in some hashie attribute
  def method_missing(method, *args)
    data.send(method, *args)
  end
end
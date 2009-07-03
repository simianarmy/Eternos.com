# $Id$
#
# Table-less class for Timeline events
class TimelineEvent
  attr_reader :event
  
  def initialize(object)
    @event = object
  end
end

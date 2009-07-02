# $Id$
#
# Standalone helper class for timeline search queries

class TimelineRequestResponse
  # events: collection of TimelineEvent objects
  def initialize(opts={})
    @events = []
    @status = 200
    @details = nil
    @response = {
      :resultCount => 0,
      :previousDataUri => nil,
      :futureDataUri => nil,
      :results => []
    }
  end
  
  def to_json
    @response[:resultCount] = @events.size
    @response[:results] ||= @events.map(&:to_json)
    @response.to_json
  end
end

# $Id$
#
# Standalone helper class for timeline search queries

class TimelineRequestResponse
  # events: collection of TimelineEvent objects
  attr_writer :results
  
  def initialize(uri)
    @results = []
    @status = 200
    @details = nil
    @response = {
      :request => uri,
      :resultCount => 0,
      :previousDataUri => nil,
      :futureDataUri => nil,
      :results => []
    }
  end
  
  def to_json
    @response.merge!(:resultCount => @results.size,
      :results => @results,
      :status => @status,
      :responseDetails => @details).to_json
  end
end

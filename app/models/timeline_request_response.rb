# $Id$
#
# Standalone helper class for timeline search queries

class TimelineRequestResponse
  # events: collection of TimelineEvent objects
  attr_writer :results
  
  def initialize(uri)
    @uri = uri
    @results = []
    @status = 200
    @details = nil
    @response = {
      :request => @uri,
      :resultCount => 0,
      :previousDataUri => nil,
      :futureDataUri => nil,
      :results => []
    }
  end
  
  def to_json
    search_events
    @response.merge!(:resultCount => @results.size,
      :results => @results,
      :status => @status,
      :responseDetails => @details).to_json
  end
  
private
  def search_events
    uri = URI.split(@uri)[5].split("/")
    member_id, start_date, end_date, options = uri[3, uri.size-1]
    events = TimelineSearch.new(member_id, "#{start_date}/#{end_date}", options)
    @results.concat(events.results)
  end
end

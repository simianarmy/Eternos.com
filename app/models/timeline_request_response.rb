# $Id$
#
# Standalone helper class for timeline search queries

class TimelineRequestResponse
  # events: collection of TimelineEvent objects
  attr_writer :results
  
  def initialize(uri, params={})
    @uri        = uri
    @params     = params
    @options    = parse_search_filters(params[:filters])
    @results    = []
    @status     = 200
    @details    = nil
    @response   = {
      :request          => @uri,
      :resultCount      => 0,
      :previousDataUri  => nil,
      :futureDataUri    => nil,
      :results          => []
    }
  end
  
  def execute
    search_events
  end
  
  def to_json
    @response.merge!(:resultCount => @results.size,
      :results => @results,
      :status => @status,
      :responseDetails => @details).to_json
  end
  
private

  # Parses rest uri for actions & opts
  def search_events
    klass = @options[:fake] ? TimelineSearchFaker : TimelineSearch
    search = klass.new(@params[:id], [@params[:start_date], @params[:end_date]], @options)
    @results = search.results
  end
  
  def parse_search_filters(args)
    (args || []).inject({}) do |res, el| 
      k,v = el.to_s.split('=')
      res[k.to_sym] = v.nil? ? "1" : v
      res
    end
  end
end

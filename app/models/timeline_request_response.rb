# $Id$
#
# Standalone helper class for timeline search queries

require 'timeline_search'

class TimelineRequestResponse
  # events: collection of TimelineEvent objects
  attr_writer :results
  
  def initialize(uri, params={})
    @uri        = uri
    @params     = params
    @options    = parse_search_filters(params[:filters])
    @results    = nil
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
  
  def to_json
    @results ||= search_events
    @response.merge!(:resultCount => @results.size,
      :results => @results,
      :status => @status,
      :responseDetails => @details).to_json
  end
  
private

  # Parses rest uri for actions & opts
  def search_events
    RAILS_DEFAULT_LOGGER.debug @options.inspect
    
    if ENV['RAILS_ENV'] == 'development'
      klass = @options[:fake] ? TimelineSearchFaker : TimelineSearch
      id = @params[:id]
    else
      klass = TimelineSearch
      # Enable use of params[:id] once member + guest checking enabled
      id = current_user.id 
    end
    klass.new(id, [@params[:start_date], @params[:end_date]], @options).results
  end
  
  def parse_search_filters(args)
    (args || []).inject({}) do |res, el| 
      el.split('&').each do |kv|
        k,v = kv.to_s.split('=')
        res[k.to_sym] = v.nil? ? "1" : v
      end
      res
    end
  end
end

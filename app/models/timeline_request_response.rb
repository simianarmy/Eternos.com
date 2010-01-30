# $Id$
#
# Standalone helper class for timeline search queries

require 'timeline_search'

class TimelineRequestResponse
  # events: collection of TimelineEvent objects
  attr_writer :results
  
  def initialize(user_id, uri, params, options)
    @id         = user_id
    @uri        = uri
    @params     = params
    @options    = options
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
      :responseDetails => @details)
    @response.to_json
  end
  
private

  # Parses rest uri for actions & opts
  def search_events
    id = if @options[:mapped]
      klass = @options[:fake] ? TimelineSearchFaker : TimelineSearch
      @params[:id]
    elsif @id > 0
      klass = TimelineSearch
      # Enable use of params[:id] once member + guest checking enabled
      @id
    else
      RAILS_DEFAULT_LOGGER.warn "Unable to determine search user id"
      nil
    end
    RAILS_DEFAULT_LOGGER.debug "search member id = #{id}"
    return unless id
    
    klass.new(id, [@params[:start_date], @params[:end_date]], @options).results
  end
end

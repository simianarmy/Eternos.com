# $Id$
#
# Table-less class for Timeline events
class TimelineEvent
  attr_accessor :start_date, :end_date 
  attr_reader :type, :attributes

  def initialize(object)
    @attributes = object.attributes.dup
    @type = object.class.to_s

    # Add media content url & thumbnail url for html display
    if object.kind_of?(Content) ||
      (object.kind_of?(ActivityStreamItem) && object.attachment_data)
      @attributes.merge! :url => object.url, :thumbnail_url => object.thumbnail_url
    end
    # Determine event start & end dates
    if object.respond_to? :published_at
      @start_date = object.published_at
    elsif object.respond_to? :start_at
      @start_date = object.start_at
      @end_date = object.end_at if object.respond_to? :end_at
    else
      @start_date = object.created_at
    end  
  end
end

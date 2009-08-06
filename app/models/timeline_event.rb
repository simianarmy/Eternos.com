# $Id$
#
# Table-less class for Timeline events
class TimelineEvent
  attr_accessor :start_date, :end_date 
  attr_reader :type, :attributes
  
  def initialize(object)
    @type = object.class.to_s
    if object.respond_to? :published_at
      @start_date = object.published_at
    elsif object.respond_to? :start_at
      @start_date = object.start_at
      @end_date = object.end_at if object.respond_to? :end_at
    else
      @start_date = object.created_at
    end  
    @attributes = object.attributes
  end
end

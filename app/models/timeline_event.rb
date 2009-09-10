# $Id$
#
# Table-less class for Timeline events
class TimelineEvent
  attr_accessor :start_date, :end_date
  attr_reader :type, :attributes
  
  def initialize(obj)
    @attributes = obj #.attributes.dup
    @type = object_type(obj)
    @start_date = obj.start_date
    @end_date = obj.try(:end_date)
  end
  
  private
  
  def object_type(obj)
    activity_stream_media_attachment?(obj) ? obj.attachment_type.capitalize : obj.class.to_s
  end
  
  def activity_stream_media_attachment?(obj)
    obj.kind_of?(ActivityStreamItem) && obj.media_attachment?
  end
end

# $Id$
#
# Table-less class for Timeline events
class TimelineEvent
  attr_accessor :start_date, :end_date
  attr_reader :type, :attachment_type, :event
  
  # We need to force event to be serialized with as_json...
  # This looks like the only way to do it
  def to_json(options={})
    {
      :start_date => start_date,
      :end_date => end_date,
      :type => type,
      :attachment_type => attachment_type,
      :attributes => event
    }.to_json(options)
  end
  
  def initialize(obj)
    @event = obj
    @type = obj.to_str
    @attachment_type = find_attachment_type(obj)
    date = obj.try(:start_date) || obj.try(:start_at)
    @start_date = date.to_s if date
    date = obj.try(:end_date) || obj.try(:end_at)
    @end_date = date.to_s if date
  end
  
  private
  
  def find_attachment_type(obj)
    (obj.respond_to?(:media_attachment?) && obj.media_attachment?) ? obj.attachment_type.downcase : nil
  end
  
end

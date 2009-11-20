# $Id$
#
# Table-less class for Timeline events
class TimelineEvent
  attr_accessor :start_date, :end_date
  attr_reader :type, :attachment_type, :attributes
  
  def to_json
    result = {:type => type,
      :start_date => start_date,
      :end_date => end_date,
      :attachment_type => attachment_type,
      :attributes => attributes
    }.to_json
  end
  
  def initialize(obj)
    @attributes = obj
    @type = obj.to_str
    @attachment_type = find_attachment_type(obj)
    @start_date = obj.try(:start_date) || obj.try(:start_at)
    @end_date = obj.try(:end_date) || obj.try(:end_at)
  end
  
  private
  
  def find_attachment_type(obj)
    obj.try(:media_attachment?) ? obj.attachment_type.downcase : nil
  end
  
end

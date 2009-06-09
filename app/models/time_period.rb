# $Id$
# TimePeriod
#
# Object implementing date/time range

class TimePeriod
  attr_accessor :beginning, :end
  attr_reader :error
  
  def initialize(beginning=nil, end_time=nil)
    @beginning, @end = beginning, end_time
    @error = ''
  end
  
  def to_s
    if empty?
      s = I18n.t 'models.time_period.timeless'
    else
      s = date_to_s(@beginning)
      if !@end.nil? 
        if (@beginning != @end)
          s += " to #{date_to_s(@end)}"
        else
          s += " to ?"
        end
      end
    end
    s
  end
  
  def empty?
    @beginning.blank?
  end
  
  def has_time?
    @beginning.hour > 0 || @end.hour > 0
  end
  
  def clear
    @beginning = @end = nil
  end
  
  def valid?
    @error = ''
    if @beginning.nil? and !@end.nil?
        @error = "Please Enter A Start Date"
    elsif !(@beginning.nil? || @end.nil?) && (@end < beginning)
        @error = "End Date Must Occur After Start Date"
    end
    @error.empty?
  end
  
  private
  
  def date_to_s(date)
    date.hour > 0 || date.min > 0 ? date.to_formatted_s(:time_period_date_with_time) : date.to_formatted_s(:time_period_date)
  end
end

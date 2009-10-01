# $Id$
module TimelinesHelper
  def fields_for_time_period(object, name, &block)
    fields_for("#{object.class.to_s.underscore}[time_period][#{name.to_s}]", object, &block)
  end
  
  # Takes time period object and symbol specifying beginning or end
  # Returns html for selecting datetime with selects & calendar
  def time_period_select(object, period)
    fields_for_time_period(object, period) do |tp_f|
      tp_f.datetime_select_with_datepicker(period, {:include_blank => true, :start_year => 1900, 
        :default => object.send(period), :add_month_numbers => true, :order => [:year,:month,:day]}, 
        {:class => "time_period_date"})
    end
  end
  
  # Returns time period string if not timeless, otherwise returns date
  # specified by other attribute
  def time_period_or(object, other)
    if object.time_period.empty?
      publish_date(object.send(other))
    else
      object.time_period.to_s
    end
  end

  def backup_progress_icon(name)
    icon = name.downcase + (%w( facebook twitter ).include?(name) ? '.gif' : '.png')
    
    "<img alt='#{name}' style='width:12px;height:12px;' src='/javascripts/timeline/icons/#{icon}'>"
  end
end

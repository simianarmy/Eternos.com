class TimePeriodRenderer < Renderer
  def update(time_period, container)
    if flash[:error]
       page.visual_effect :highlight, :time_period_selects, :duration => 2.0
     else
       page.replace_html :time_period, time_period.to_s
       page.visual_effect :highlight, :time_period
       # Reload hidden form partial with possible new values
       page.replace_html :time_period_select, :partial => "shared/ajax_time_period_select_form", 
         :object => container, :locals => {:period => time_period}
       page.call 'toggle_show_select_display', 'time_period'
     end
  end
end
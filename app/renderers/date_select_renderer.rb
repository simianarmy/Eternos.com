# $Id$

class DateSelectRenderer < Renderer
  def update(newValue, dateSelId)
    page.replace_html dateSelId, newValue
    page.hide "#{dateSelId}_form"
    page.show dateSelId
    page.visual_effect :highlight, dateSelId, :duration => 2.0
  end
end
  
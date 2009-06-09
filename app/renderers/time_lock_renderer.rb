# $Id$

class TimeLockRenderer < Renderer
  def update(dated=false)
    page.visual_effect :highlight, :time_lock
    page.hide :unlock_date
    if dated
      page.show :toggle_unlock_date
    else
      page.hide :toggle_unlock_date
    end
  end
end
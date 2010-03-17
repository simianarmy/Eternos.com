# $Id$

module TooltipsHelper
  def default_prototip_options
    "hook: {target: 'topRight', tip: 'bottomLeft'}, stem: 'bottomLeft'"
  end
  
  # Generates custom Prototip step/hook options string in JSON format
  def prototip_options_for_div(div)
    "{target: $('#{div}'), hook: {target: 'topMiddle', tip: 'bottomMiddle'}, stem: 'bottomLeft'}"
  end
end
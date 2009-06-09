# $Id$

module TabsHelper
  # For tabs with contents already rendered in main page
  def link_to_tab(name)
    link_to_function(name.humanize.capitalize, "tabselect($('#{name}_tab')); paneselect($('#{name}_pane'))")
  end
  
  # For tabs that dynamically load contents
  def link_to_ajax_tab(name, ajax_url)
    link_to_function(name.humanize.capitalize, 
      "loadPane($('#{name}_pane'), '#{ajax_url}'), tabselect($('#{name}_tab')); paneselect($('#{name}_pane'))")
  end
end
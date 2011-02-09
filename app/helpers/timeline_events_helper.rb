# $Id$

module TimelineEventsHelper
  # Displays close button for timeline/search item details div
  # Takes optional options hash to override default behavior
  def item_details_close_button(id, opts={})
    if opts[:on_click]
      link_to_function image_tag('delete-icon-16.png'), opts[:on_click]
    else
      link_to_function image_tag('delete-icon-16.png'), 
        update_page { |page| page.visual_effect 'SlideUp', id}
    end
  end
end

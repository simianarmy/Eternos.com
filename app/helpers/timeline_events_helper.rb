# $Id$

module TimelineEventsHelper
 
  def item_details_close_button(id)
    link_to_function image_tag('delete-icon-16.png'), 
      update_page { |page| page.visual_effect 'SlideUp', id}
  end
end

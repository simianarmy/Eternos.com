# $Id$

module TimelineEventsHelper
  def item_details_close_button
    link_to_function image_tag('delete-icon-16.png'), 
      update_page { |page| page.visual_effect 'SlideUp', :item_details_content}
  end
end

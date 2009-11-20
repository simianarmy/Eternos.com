# $Id$

class ProfileRenderer < Renderer

  # RJS for new_ action
  def new_entry(object, options={})
    obj_name = object.to_str
    page.call "spinner.unload"
    unless object.new_record?
      page.flash_and_fade "#{obj_name}_notice"
      page.remove "new_#{obj_name}"
      page.insert_html :bottom, "table-#{obj_name.pluralize}", :partial => obj_name.pluralize, 
        :locals => { obj_name.pluralize.to_sym => [object] }
      page.visual_effect :highlight, dom_id(object)
    else
      page.show_flash "#{obj_name}_notice"
    end
  end
end
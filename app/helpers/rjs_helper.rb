# $Id$
module RjsHelper
  # RJS helpers
  
  # Necessary in order to use ActionView::Helper methods
  # Examples:
  #   mydom = page.context.dom_id(record)
  #   page.context.flash[:notice]
  
  def context
    page.instance_variable_get("@context").instance_variable_get("@template")
  end
  
  def remove_item(id)
    page.visual_effect :highlight, id
    page.visual_effect :toggle_appear, id
  end
  
  # Displays any flash notices
  def show_flash(domid = :notice)
    unless page.context.flash.empty?
      page.replace_html domid, page.context.show_flash_messages
      page.visual_effect :appear, domid
      page.context.flash.discard
    end
  end
  
  def flash_and_fade(domid = :notice)
    unless page.context.flash.empty?
      page.replace_html domid, page.context.show_flash_messages
      page.visual_effect :appear, domid
      page.delay(3) do
        page.visual_effect :fade, domid
      end
      page.context.flash.discard
    end
  end
  
  def toggle_div(div)
    update_page do |page|
      page[div].toggle
      page[div].visual_effect :highlight
    end    
  end
  
  def hide_div(div)
    update_page do |page|
      page[div].hide
    end
  end
  
  def update_common_settings(object, settings={})
    if c = settings[:category]
      render_with :categories do |cat|
        cat.update_selected(c, object, :toggle_category_select)
      end
    elsif t = settings[:time_period]
      render_with :time_period do |tp|
        tp.update(t, object)
      end
    elsif settings[:authorization]
      partial = object.privacy_setting.partial? # Do this outside of render_with!
      render_with :authorization do |auth|
        auth.update(partial)
      end
    elsif settings[:time_lock]
      dated = object.date_locked?
      render_with :time_lock do |tl|
        tl.update(dated)
      end
    end
  end
end

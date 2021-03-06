# $Id$
module AjaxHelper
  # Adds ajax in-place-editor code for some attribute
  # to work with REST controllers
  # Takes optional value string.  If not passed, we will try to get from object
  # Borrows some from editable_content_tag that I found after finishing this
  def restful_in_place_editor(elemtype, obj, attr, options={}, editOptions = {}, ajaxOptions = {})
    objname = options.has_key?(:object) ? options[:object] : obj.to_str
    domid = dom_id(obj) + "_#{attr}"
    options[:url] = url_for(obj) unless options.has_key? :url
    options[:id] = domid unless options.has_key? :id
    options[:class] ||= 'inplaceeditor-form'
    
    #edops = jsonify editOptions
    #ajops = jsonify ajaxOptions

    if options[:value].nil?
      val = obj.respond_to?(attr) ? obj.send(attr) : ''
    else
      val = options[:value]
    end
    tg = content_tag  elemtype, 
                      val,
                      options = options

    options.merge!({
      :options => "
      { onLoading: function(transport, element){spinner.load('#{domid}')}, 
        method: 'put'
      }",
      :with => "'domId=#{domid}&#{objname}[#{attr}]=' +escape($F(Form.findFirstElement(form)))",
      :script => true,
      :cols => 40,
      :save_text => 'Save',
      :saving_text => "Updating..."
      })
    options.merge! editOptions
    
    tg + in_place_editor(domid, options)
  end
  
  # link_to_remote helper that adds ajax busy spinner on load
  # => busy_element: name of overlay id element for spinner
  def link_to_remote_busy(busy_element_id, title, ajax_options, *args)
    link_to_remote(title, ajax_options.merge(ajax_busy_options(busy_element_id)), *args)
  end
  
  # Helper to add common options values for ajax loading "busy" spinner
  def ajax_busy_options(element_id)
    {:loading => "load_busy($('#{element_id}'))", :complete => "unload_busy()"}
  end
  
  def format_ajax_errors
    render :partial => 'shared/ajax_errors'
  end
  
  def format_ajax_notice
    render :partial => 'shared/ajax_notice'
  end
  
  def link_to_show_hide(id, name = "", option = {}, element_to_hide=[])
    action = "$('#{id}').show();"
    element_to_hide.each do |element|
      action += "$('#{element}').hide();"
    end
    link_to_function name, action, option
  end
  
  def link_to_show_hide_online(id, name = "", elements_to_hide = [], options = {})
    action = "$('#{id}').show();"
    elements_to_hide.each do |element|
      action += "$('#{element}').hide();"
    end
    link_to_function name, action, options
  end
  
end

# $Id$
module AjaxHelper
  # Adds ajax in-place-editor code for some attribute
  # to work with REST controllers
  # Takes optional value string.  If not passed, we will try to get from object
  # Borrows some from editable_content_tag that I found after finishing this
  def restful_in_place_editor(elemtype, obj, attr, options={}, editOptions = {}, ajaxOptions = {})
    objname = options.has_key?(:object) ? options[:object] : obj.class.to_s.downcase
    domid = dom_id(obj) + "_#{attr}"  
    options[:url] = url_for(obj) unless options.has_key? :url
    options[:id] = domid unless options.has_key? :id
    
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
      { onLoading: function(transport, element){load_busy($('#{domid}'))}, 
        method: 'put'
      }",
      :with => "'domId=#{domid}&#{objname}[#{attr}]=' +escape($F(Form.findFirstElement(form)))",
      :script => true,
      :cols => 40,
      :save_text => "Update"
      })
    
    tg += in_place_editor(domid, options)
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

  def setup_layout_account_setting(page, active_link, partial_content)
    page.replace "account-setting-nav", :partial => "account_settings/setting_nav",
      :locals => {:active_link => active_link }, :layout => false
    page.replace "account-setting-content", :partial => partial_content, :layout => false
  end

  def link_to_show_hide(id, name = "", option = {}, element_to_hide=[])
    action = "$('#{id}').show();"
    element_to_hide.each do |element|
      action += "$('#{element}').hide();"
    end
    link_to_function name, action, option
  end
  
end

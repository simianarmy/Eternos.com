# $Id$
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def time_zone_submit_onselect(object, method,  button_target, priority = nil, option={}, html_option = {})
    action = {:onchange => "$('#{button_target}').click();"}
    html_option.update(action)
    object.time_zone_select(method, priority, option, html_option)
  end
  
  def text_field_submit_onchange(object, method, button_target)
    object.text_field(method, :onchange => "$('#{button_target}').click();")
  end

  def radio_submit_onclick(object, method, value, button_target, default, className)
    if !default.blank? and default == value
      checked = true
    else
      checked = false
    end
    object.radio_button(method, value, :onClick => "$('#{button_target}').click();", :checked => checked, :class => className)
  end

  def date_select_onchange(object, method, button_target)
    object.calendar_date_select(method, :embedded => true, 
      :onchange => "$('#{button_target}').click();", :year_range => 100.years.ago..10.years.ago)
  end

  def hidden_submit(id)
    submit_tag "submit", :style=>"display:none;", :id => id
  end

  def flash_notices
    [:notice, :error].collect {|type| content_tag('div', flash[type], :id => "flash_#{type}") if flash[type] }
  end
  
  alias_method :show_flash_messages, :flash_notices
  
  # Render a submit button and cancel link
  def submit_or_cancel(cancel_url = session[:return_to] ? session[:return_to] : url_for(:action => 'index'), label = 'Save Changes')
    content_tag(:div, submit_tag(label) + ' or ' +
      link_to('Cancel', cancel_url), :id => 'submit_or_cancel', :class => 'submit')
  end
  
  # Custom form builder helpers
  def error_handling_form_for(record_or_name_or_array, *args, &proc)
    options = parse_options(args)
    form_for(record_or_name_or_array, *args, &proc)
  end
  
  def remote_error_handling_form_for(record_or_name_or_array, *args, &proc)
    options = parse_options(args)
    remote_form_for(record_or_name_or_array, *args, &proc)
  end
  
  def link_to_support_email
    mail_to(AppConfig.support_email, 'email&nbsp;support')
  end
  
  # Creates standard form errors box using localization
  def custom_error_messages_for(*args)
    options = args.last.kind_of?(Hash) ? args.pop : {}
    options.reverse_merge!(
      :full_messages => true,
      :header_message => t('activerecord.errors.template.header.oops'),
      :message => t('activerecord.errors.template.body', 
        :email_link => link_to_support_email))
    args << options
    error_messages_for(*args)
  end
  
  # swf_object
  def swf_object(swf, id, width, height, flash_version, background_color, params = {}, vars = {}, create_div = false)
    # create div ?
    create_div ? output = "<div id=’#{id}‘>This website requires <a href=’http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash&promoid=BIOW’ target=’_blank’>Flash player</a> #{flash_version} or higher.</div><script type=’text/javascript’>" : output = "<script type=’text/javascript’>"
    output << "var so = new SWFObject(’#{swf}‘, ‘#{id}‘, ‘#{width}‘, ‘#{height}‘, ‘#{flash_version}‘, ‘#{background_color}‘);"
    params.each  {|key, value| output << "so.addParam(’#{key}‘, ‘#{value}‘);"}
    vars.each    {|key, value| output << "so.addVariable(’#{key}‘, ‘#{value}‘);"}
    output << "so.write(’#{id}‘);"
    output << "</script>"
  end
    
  # This might be in the rails libs somewhere...
  # but use this till I find it
  def base_url
    request.protocol + request.host_with_port
  end
  
  def hide_login_box
    @hide_login_box = true
  end
  
  # Add localization option arg to method call
  def number_to_currency(number, options={})
    options[:locale] ||= I18n.locale
    ActionView::Helpers::NumberHelper::number_to_currency number, options
  end
  
  def publish_date(date)
    I18n.l(date, :format => :long)
  end
  
  private
  
  def parse_options(args)
    options = args.detect { |argument| argument.is_a?(Hash) }
    if options.nil?
      options = {:builder => ErrorHandlingFormBuilder}
      args << options
    end
    options[:builder] = ErrorHandlingFormBuilder unless options.nil?
  end
end


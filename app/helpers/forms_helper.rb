# $Id$

module FormsHelper
  
  def user_session
    @user_session ||= UserSession.new
  end
  
  def form_for_using_ssl(record_or_name_or_array, *args, &block)
    options = args.extract_options!
    options[:url] ||= {}
    if options[:url].is_a? Hash
      options[:url].merge!(:protocol => 'https', :only_path => false)
    end
    args << options  
    form_for(record_or_name_or_array, *args, &block)
  end
  
  def form_remote_for_using_ssl(record_or_name_or_array, *args, &block)
    options = args.extract_options!
    options[:url] ||= {}
    options[:url].merge!(:protocol => 'https', :only_path => false)
    args << options  
    form_remote_for(record_or_name_or_array, *args, &block)
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
  
  # Creates standard form errors box using localization
  def custom_form_error_header(*args)
    header = t('activerecord.errors.template.header.oops')
    message = t('activerecord.errors.template.body', 
      :email_link => link_to_support_email)
    
    content_tag(:div, :id => "errorExplanation", :class => "errorExplanation") do
      content_tag(:h2, header) +
      content_tag(:p, message)
    end
  end
  
  # Template helper for generic forms
  def form_field_with_label(form, field, options={})
    render :partial => 'forms/field',
        :locals => { :element => form.text_field(field, options),
          :label => form.label(field, options[:label])
          }
  end
  
  def fields_for_phone_number(phone, owner, *args, &block)
    fields_for_association('phone_number', phone, owner, *args, &block)
  end
  
  def fields_for_job(job, owner, *args, &block)
    fields_for_association('career', job, owner, *args, &block)
  end
  
  def fields_for_school(school, owner, *args, &block)
    fields_for_association('school', school, owner, *args, &block)
  end
  
  def ajax_file_upload_iframe(id)
    "<iframe id='#{id}' style='width:1px;height:1px;border:0px' src='about:blank' name='#{id}'></iframe>"
  end
  
  def check_box_submit_on_click(method, button_target, value, default, option={})
    action = { :onclick => "$('#{button_target}').click();" }
    option.update(action)
    check_box_tag(method, value, default, option)
   end
  
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
  
  def tags_field_description
    render :partial => 'shared/tags_field_hint'
  end
  
  private
  
  def fields_for_association(name, object, parent, *args, &block)
    prefix = object.new_record? ? 'new' : 'existing'
    fields_for("#{parent}[#{prefix}_#{name}_attributes][]", object, *args, &block)
  end
end
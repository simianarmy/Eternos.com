# $Id$
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def flash_notices(options={})
    returning String.new do |html|
      [:notice, :error].collect do |type| 
        if flash[type]
          html << content_tag('div', flash[type], :id => "flash_#{type}")
          if options.key?(:fade)
            html << javascript_tag("setTimeout(function() { new Effect.Fade('flash_#{type}') }, #{options[:fade]*1000});")
          end
        end
      end
    end
  end
  
  alias_method :show_flash_messages, :flash_notices
  
  def link_to_support_email
    mail_to(AppConfig.support_email, 'email&nbsp;support')
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
  
  def session_timeout_seconds
    SESSION_DURATION_SECONDS
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


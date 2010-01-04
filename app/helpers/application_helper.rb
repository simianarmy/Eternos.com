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
      flash.clear
    end
  end
  
  alias_method :show_flash_messages, :flash_notices
  
  def link_to_support_email
    mail_to(AppConfig.support_email, 'email&nbsp;support')
  end
  
  def discount_label(discount)
    (discount.percent? ? number_to_percentage(discount.amount * 100, :precision => 0) : number_to_currency(discount.amount)) + ' off'
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
  # def number_to_currency(number, options={})
  #     options[:locale] ||= I18n.locale
  #     ActionView::Helpers::NumberHelper::number_to_currency number, options
  #   end
  
  def publish_date(date)
    I18n.l(date, :format => :long) if date
  end
  
  def profile_view_date(date)
    I18n.l(date, :format => :long) if date
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


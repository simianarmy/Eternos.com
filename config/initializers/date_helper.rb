# $Id$

module ActionView
  module Helpers
    module DateHelper
      def build_base_id(method, options={}, html_options={})
        base_id = options[:object] ? dom_id(options[:object]) : (html_options[:object_id] || method.to_s)
        base_id += "-#{method.to_s}"
      end
      
      def date_select_with_datepicker(object_name, method, options = {}, html_options = {})
        id = build_base_id(method, options, html_options)
        date_select(object_name, method, options, html_options.merge(
          datepicker_html_options(id))) << datepicker_button_html(id)
      end
      
      def datetime_select_with_datepicker(object_name, method, options = {}, html_options = {})
        id = build_base_id(method, options, html_options)
        datetime_select(object_name, method, options, html_options.merge(
          datepicker_html_options(id))) << datepicker_button_html(id)
      end
      
      def datepicker_html_options(id)
        {:year_class => "split-date button-butt-wrapper-#{id}",
        :id => "#{id}-date-sel"}
      end
      
      def datepicker_button_html(id)
        content_tag(:span, '', :id => "butt-wrapper-#{id}")
      end
    end
  
    class DateTimeSelector
      # Override to add custom ID tags to month & day selects for 
      # javascript calendar
      def build_select(type, select_options_as_html)
        select_options = {
          :id => input_id_from_type(type),
          :name => input_name_from_type(type),
          :class => ''
        }.merge(@html_options)
        
        if @html_options[:id]
          select_options[:id] += "-mm" if type == :month
          select_options[:id] += "-dd" if type == :day
        end
        
        if @html_options[:year_class] && (type == :year)
          select_options[:class] += ' ' + @html_options.delete(:year_class)
        end
        select_options.merge!(:disabled => 'disabled') if @options[:disabled]

        select_html = "\n"
        select_html << content_tag(:option, '', :value => '') + "\n" if @options[:include_blank]
        select_html << select_options_as_html.to_s

        content_tag(:select, select_html, select_options) + "\n"
      end
    end
    
    class FormBuilder
      def date_select_with_datepicker(method, options = {}, html_options = {})
        @template.date_select_with_datepicker(@object_name, method, options.merge(:object => @object),
           html_options)
      end
      
      def datetime_select_with_datepicker(method, options = {}, html_options = {})
        @template.datetime_select_with_datepicker(@object_name, method, options.merge(:object => @object),
           html_options)
      end
    end
  end
end
      
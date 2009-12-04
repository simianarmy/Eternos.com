# $Id$
module ActionView
  module Helpers
    module ActiveRecordHelper
      def error_messages_for(*params)
        options = params.extract_options!.symbolize_keys
                  
        if object = options.delete(:object)
          objects = [object].flatten
        else
          objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
        end
        # Discard errors without messages
        objects.map {|object| object.errors.each { |column,error| object.errors.delete(column) if error.blank? || (error == 'is invalid') } } 
          
        count   = objects.inject(0) {|sum, object| sum + object.errors.count }
        unless count.zero?
          html = {}
          [:id, :class].each do |key|
            if options.include?(key)
              value = options[key]
              html[key] = value unless value.blank?
            else
              html[key] = 'errorExplanation'
            end
          end
          options[:object_name] ||= params.first
          #options[:header_message] = "#{pluralize(count, 'error')} prohibited this #{options[:object_name].to_s.gsub('_', ' ')} from being saved" unless options.include?(:header_message)
          #options[:message] ||= 'There were problems with the following fields:' unless options.include?(:message)
          #error_messages = objects.sum {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }.join
         
          error_messages = objects.map do |object| 
            (options[:full_messages] ? object.errors.full_messages : object.errors).map {|error| content_tag( :li, error ) }
          end

          contents = ''
          contents << content_tag(options[:header_tag] || :h2, options[:header_message]) unless options[:header_message].blank?
          contents << content_tag(:p, options[:message]) unless options[:message].blank?
          contents << content_tag(:ul, error_messages)

          content_tag(:div, contents, html)
        else
          ''
        end
      end
    end
  end
end

module ActiveRecord
  class Base
    extend Searchable
    
    def to_str
      self.class.to_s.underscore
    end
  end

  class Errors
    # Remove a single error from the collection by key. 
    def delete(key) 
      @errors.delete(key.to_s) 
    end
    
    # Override to only use message values if not blank
    def full_messages
      @errors.values.flatten
    end
  end
end


# monkey patch action mailer (Rails 2.2) to not use layouts for text/plain emails
# module ActionMailer
#   class Base
#     private
#     def candidate_for_layout?(options)
#       (!options[:file] || !options[:file].respond_to?(:content_type) ||
#       options[:file].content_type != 'text/plain') &&
#       !@template.send(:_exempt_from_layout?, default_template_name)
#     end
#   end
# end


module MIME
  class Type
    def typical_file_extension
      @glob_patterns.first.gsub("*", "") if @glob_patterns
    end
  end  

  module Magic
    class << self
      def check(filename)
        check_special(filename) ||
        open(filename) { |f|
          check_magics_with_priority(f, 80) ||
          check_magics_with_priority(f, 0) ||
          check_default(f)
        }
      end
    end
  end
end



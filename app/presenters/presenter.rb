# $Id$ 
#
# 
# from Jay Fields http://blog.jayfields.com/2007/03/rails-presenter-pattern.html
# adapted by Mike Subelsky (http://subelsky.com/) to include ActiveRecord error combination

# Hopefully the right place for this base class
# All presenters should inherit from this

require 'decorations'

class Presenter

  # Complex hack to use ActiveRecord::Errors 
  # Thanks to http://gist.github.com/191263
  def self.self_and_descendants_from_active_record
    [self]
  end

  def self.human_attribute_name(attribute_key_name, options = {})
    defaults = self_and_descendants_from_active_record.map do |klass|
      "#{klass.name.underscore}.#{attribute_key_name}""#{klass.name.underscore}.#{attribute_key_name}"
    end
    defaults << options[:default] if options[:default]
    defaults.flatten!
    defaults << attribute_key_name.humanize
    options[:count] ||= 1
    I18n.translate(defaults.shift, options.merge(:default => defaults, :scope => [:activerecord, :attributes]))
  end

  def self.human_name(options = {})
    defaults = self_and_descendants_from_active_record.map do |klass|
      "#{klass.name.underscore}""#{klass.name.underscore}"
    end 
    defaults << self.name.humanize
    I18n.translate(defaults.shift, {:scope => [:activerecord, :models], :count => 1, :default => defaults}.merge(options))
  end
  # End complex hack
  
  def initialize(params)
    params.each_pair do |attribute, value| 
      self.send :"#{attribute}=", value
    end unless params.nil?
  end

  # Combines errors from individual ActiveRecord objects, so we present something nice to the user

  def errors
    @errors ||= ActiveRecord::Errors.new(self)
  end

  # needed by error_messages_for

  def self.human_attribute_name(attrib)
    attrib.humanize
  end

  def detect_and_combine_errors(*objects)
    Rails.logger.debug "MY ERRORS = #{errors.inspect}"
    objects.each do |obj|
      next if obj.nil?
      obj.valid?
      # Need to remove pesky 'is invalid' errors from associations
      obj.errors.each { |k,m| errors.add_to_base(m) unless m == 'is invalid' }
    end
  end

  def method_missing(model_attribute, *args)
    model, *method_name = model_attribute.to_s.split("_")
    super unless self.respond_to? model.to_sym
    self.send(model.to_sym).send(method_name.join("_").to_sym, *args)
  end
end
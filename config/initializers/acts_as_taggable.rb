# $Id$

module Eternos
  module Acts
    module Taggable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_taggable_custom(options={})
          attr_accessor :tag_s
          after_create :save_tags
          
          owner_method = options[:owner_method] ? options[:owner_method] : :user
          define_method("get_user", Proc.new { 
            owner_method.is_a?(Symbol) ? self.send(owner_method) : owner_method.call(self)
          })
          
          include Eternos::Acts::Taggable::InstanceMethods
          extend Eternos::Acts::Taggable::SingletonMethods
        end
        
        def validates_presence_of_tags
          validate :validate_tags
        end
      end

      module SingletonMethods
        # Helper to find all tags associated with this class
        def tags
          Tagging.find_all_by_taggable_type(to_s).uniq
        end
      end
      
      module InstanceMethods
        def get_tags
          tag_s.blank? ? tag_list : tag_s
        end
  
        def validate_tags
          if (val = get_tags).blank? || (val == I18n.t('form.input.tags.hint'))
            errors.add(:tags, "Please enter some tags")
          end  
        end
        
        private
        # Handle tags from form mass assignement - can't use field name 
        # in form due to has_many :through: limitation:
        # ActiveRecord::Associations::PolymorphicError: You 
        # can't associate unsaved records.
        # Instead, we assign to a virtual attribute and assign after creation
        def save_tags
          tag_with(tag_s, get_user) if tag_s
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include Eternos::Acts::Taggable
end
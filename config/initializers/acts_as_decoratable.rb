# $Id$
#
# ActiveRecord extension allowing a model to be 'decorated' with 
# a list of content objects.
# Created in order to support multiple models needing this functionality
# => Element, Message

module Eternos
  module Acts
    module Decoratable

      def self.included(base)
        base.extend ClassMethods
      end
  
      module ClassMethods
        def acts_as_decoratable
          has_many :decorations, :as => :decoratable, :dependent => :destroy, 
            :order => :position
          has_many :contents, :through => :decorations

          include Eternos::Acts::Decoratable::InstanceMethods
          extend Eternos::Acts::Decoratable::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
      end
      
      module InstanceMethods
        def decorate(*objects)
          objects.uniq.each do |obj|
            contents << obj unless contents.include? obj
          end
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include Eternos::Acts::Decoratable
end
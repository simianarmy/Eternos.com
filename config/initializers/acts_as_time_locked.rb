# $Id$
# ActsAsTimeLock

require 'time_lock'

module Eternos
  module Acts
    module TimeLocked
      def self.included(base)
        base.extend ClassMethods
      end
  
      module ClassMethods
        def acts_as_time_locked(options={})
          has_one :time_lock, :as => :lockable, :dependent => :destroy
          
          validate :validate_time_lock
            
          include Eternos::Acts::TimeLocked::InstanceMethods
          extend Eternos::Acts::TimeLocked::SingletonMethods
        end        
      end
      
      # This module contains class methods
      module SingletonMethods
      end
      
      module InstanceMethods
        def time_lock_select_options
          TimeLock.select_options
        end
        
        def unlocked?
          time_lock_type == TimeLock.unlocked
        end
        
        def date_locked?
          time_lock_type == TimeLock.date_locked
        end
        
        def death_locked?
          time_lock_type == TimeLock.death_locked
        end

        # Returns type id representing type of time lock
        def time_lock_type
          case time_lock
          when DeathLock
            TimeLock.death_locked
          when TimeLock
            TimeLock.date_locked  
          else
            TimeLock.unlocked
          end
        end
        
        def new_time_lock_attributes=(attributes)
          case attributes.delete(:type).to_i
          when TimeLock.date_locked
            build_time_lock(attributes).type = "TimeLock"
          when TimeLock.death_locked
            build_time_lock.type = "DeathLock"
          end
        end
        
        def time_lock_attributes=(attributes)
          if attributes[:type].to_i == time_lock_type
            # Update date if necessary
            @time_lock_changed = false
            time_lock.update_attributes(attributes) if date_locked?
          else
            # Replace & delete existing
            # Manually specify that it will change for time_lock.changed? to work
            @time_lock_changed = true
            update_time_lock(attributes)
          end
        end

        def time_lock_changed?
          @time_lock_changed == true
        end
        
        private
        
        # Adds associated errors to object errors
        def validate_time_lock
          unless time_lock.nil? or time_lock.valid?
            time_lock.errors.each_full do |err| 
              self.errors.add :time_lock, err.gsub(/\{lockable\}/, self.to_str.humanize)
            end
          end
        end
        
        def update_time_lock(attributes)
          attributes.merge!(:lockable => self)
          case attributes.delete(:type).to_i
          when TimeLock.date_locked
            self.time_lock = TimeLock.new(attributes)
          when TimeLock.death_locked
            self.time_lock = DeathLock.new(attributes)
          else
            time_lock.destroy if time_lock
          end
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include Eternos::Acts::TimeLocked
end


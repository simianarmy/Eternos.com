# $Id$
#require 'time_period'

module Eternos
  module TimePeriod
    module ActMethods
      @@start_col = :start_at
      @@end_col = :end_at
      mattr_reader :start_col, :end_col
      
      # Options:
      # start_date column name
      # end_date column name
      #
      # Examples:
      # acts_as_time_period :starting_date, :ending_date
      # acts_as_time_period :start_at
      # acts_as_time_period
      
      def acts_as_time_period(start_date=nil, end_date=nil)
        @@start_col = start_date unless start_date.nil?
        @@end_col = end_date unless end_date.nil?
        
        composed_of :time_period, :class_name => 'TimePeriod', 
        :mapping => [[@@start_col, :beginning],[@@end_col, :end]]
        # When rails 2.2 is stable, try this, or better yet
        # screw composed_of and use attribute_decorator
        #
        #:constructor => Proc.new { |start_d, end_d| TimePeriod.new(start_d, end_d) }
        #      ,:converter => Proc.new { |start_d, end_d| 
        #        debugger
        #        }
        
        attr_accessor :timeless
        before_save :save_composed_of_attributes
        
        delegate :beginning, :to => :time_period
        delegate :end, :to => :time_period
        
        extend ClassMethods unless (class << self; included_modules; end).include?(ClassMethods)
        include InstanceMethods unless included_modules.include?(InstanceMethods)
      end
    end
    
    module ClassMethods  
      def validates_as_time_period
        validate :valid_dates?
      end
    end
    
    module InstanceMethods
      #  Override attributes=() & update_attributes()
      # to extract and save time period dates, since time_period is a composed_of 
      # class and it's attributes are composed_of Time objects...
      # Normal update_attributes not catching that nested level
      # defining a time_period= method doesn't seem to work
      # Also, simply assigning parsed dates to the time_period attributes 
      # doesn't do anything to the underlying record columns...so we need
      # to define a before_save that assigns time_period attributs to associated
      # attributes...damn, what was the point of composed_of again?
      
      def attributes=(attributes)
        update_time_period_from_attributes(attributes)
        super
      end
      
      def update_attributes(attributes)
        update_time_period_from_attributes(attributes)
        super
      end
      
      def update_time_period_from_attributes(attributes)
        return if attributes.nil?
        if attributes[:timeless] == "1"
          time_period.clear
        else
          if !attributes.nil? && !attributes[:time_period].nil?
            vals = extract_callstack_for_multiparameter_attributes(attributes[:time_period][:beginning].merge(attributes[:time_period][:end]))
            if vals["beginning"] && !vals["beginning"].empty?
              time_period.beginning = DateTime.new(*vals["beginning"])
            end
            if vals["end"] && !vals["end"].empty?
              time_period.end = DateTime.new(*vals["end"])
            end
          end
        end
        attributes.delete(:time_period)
      end
      
      # before save callback to reflect composed of attributes to record
      # why this isn't done by Rails is beyond me...it's supposed to
      def save_composed_of_attributes
        # Find better way to access class attributes
        write_attribute(Eternos::TimePeriod::ActMethods::start_col, time_period.beginning)
        write_attribute(Eternos::TimePeriod::ActMethods::end_col, time_period.end)
      end
      
      def valid_dates?
        if !time_period.valid?
          errors.add("Time Period: ", time_period.error)
        end
      end
    end
  end
end

ActiveRecord::Base.extend Eternos::TimePeriod::ActMethods

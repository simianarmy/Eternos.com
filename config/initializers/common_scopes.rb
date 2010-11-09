# $Id$

# Include this module in AR classes that use acts_as_archivable.
# Adds helpful named_scopes for date searches.
# If you don't care about time/date comparison mismatches in sql, use standard acts_as_archivable methods.
module CommonDateScopes
  def self.included(base)
    base.class_eval do
      raise "Unknown archivable attribute - you must call acts_as_archivable in this model!" unless self.respond_to?(:archivable_attribute)      
      named_scope :latest, lambda { |num|
        { :order => self.archivable_attribute.to_s + ' DESC', :limit => num || 1 }
      }
      named_scope :between_dates, lambda {|s, e| 
        { :conditions => ["DATE(#{self.archivable_attribute.to_s}) BETWEEN ? AND ?", s, e] }
      }
      named_scope :before, lambda {|date|
        { 
          #:conditions => ["(#{self.archivable_attribute.to_s} IS NULL) OR (DATE(#{self.archivable_attribute.to_s}) <= ?)", 
          :conditions => ["#{self.table_name}.#{self.archivable_attribute.to_s} <= ?", date] 
        }
      }
      named_scope :after, lambda {|date|
        { 
          :conditions => ["#{self.table_name}.#{self.archivable_attribute.to_s} >= ?", date] 
        }
      }
      named_scope :sorted, lambda {
        { :order => "#{self.table_name}.#{self.archivable_attribute.to_s} ASC" }
      }
      named_scope :sorted_desc, lambda {
        { :order => "#{self.table_name}.#{self.archivable_attribute.to_s} DESC" }
      }
    end
  end
end

# Adds named_scopes for duration records (with start & end dates where end date can be null)
module CommonDurationScopes
  def self.included(base)
    base.class_eval do
      raise "Unknown archivable attribute - you must call acts_as_archivable in this model!" unless self.respond_to?(:archivable_attribute)
      cattr_accessor :end_archivable_attribute
      self.end_archivable_attribute = 'end_at'

      named_scope :before_duration, lambda { |end_date|
        {
          :conditions => ["(#{self.table_name}.#{self.end_archivable_attribute.to_s} IS NULL) AND (DATE(#{self.table_name}.#{self.archivable_attribute.to_s}) <= ?)", end_date]
        }
      }
      named_scope :in_dates, lambda { |start_date, end_date|
        {
          :conditions => ["(#{self.table_name}.#{self.archivable_attribute.to_s} >= ? AND #{self.table_name}.#{self.end_archivable_attribute.to_s} <= ?) OR " +
            "((#{self.table_name}.#{self.end_archivable_attribute.to_s} IS NULL) AND (#{self.table_name}.#{self.archivable_attribute.to_s} <= ?) AND (DATE(NOW()) > ?))",
            start_date, end_date,
            end_date, start_date]
          }
        }
    end
  end
end

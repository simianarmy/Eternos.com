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
        { :conditions => ["DATE(#{self.archivable_attribute.to_s}) < ?", date] }
      }
      named_scope :after, lambda {|date|
        { :conditions => ["DATE(#{self.archivable_attribute.to_s}) > ?", date] }
      }
    end
  end
end
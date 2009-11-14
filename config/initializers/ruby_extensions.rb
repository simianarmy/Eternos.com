# $Id$

# My own little additions/fixes to ruby

# try() added in Rails 2.3 - use this till then
class Object
  ##
  #   @person ? @person.name : nil
  # vs
  #   @person.try(:name)
  def try(method)
    unless self.nil?
      send method if respond_to? method
    end
  end
end

# Possessify noun
# exmample: 
# "John".possessify => "John's"
# "Davis".possessify => "Davis'"
class String
  def possessify
    self.last == 's' ? "#{self}'" : "#{self}'s"
  end
end

    

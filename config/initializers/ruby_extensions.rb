# $Id$

# My own little additions/fixes to ruby

# Possessify noun
# exmample: 
# "John".possessify => "John's"
# "Davis".possessify => "Davis'"
class String
  def possessify
    self.last == 's' ? "#{self}'" : "#{self}'s"
  end
end

    

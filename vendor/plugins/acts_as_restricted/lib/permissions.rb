# Contains permission constants for object-level authorization
# Constants used in bitfield, so should be powers of 2

# place to store bit vector preferences
# to add a new preference:-
#   add symbol of preference to @@bits with bit allocation
#   update initialize defaults if initial default is true
class Permissions
  View    = 1
  Comment = 2
  Modify  = 4
  Delete  = 8

  @@bits= {
    :view =>    View,
    :comment => Comment,
    :modify =>  Modify,
    :delete =>  Delete }
  
  # create a reader for each preference
  @@bits.each_key do |a|
    attr_reader a
  end
  
  def self.permissions_options
    opts = []
    @@bits.each_key {|a, v| opts << {a => v}}
    opts
  end
  
  # Initialize from integer or Hash
  def initialize(perms)
    if perms.nil?
      # set the defaults to false if not been set before
      @@bits.each do |a, v|
        instance_variable_set("@#{a}", false)  
      end
      # override default here        
      @view = true

    elsif perms.is_a?(Hash)
      # initialize from parameter Hash, and default to false if absent from hash
      @@bits.each do |a, v|
        instance_variable_set("@#{a}", false)  
      end
      
      perms.each do |k,v|
        # Massage value since we accept boolean & integers
        if not [TrueClass, FalseClass].include?(v.class)
          v = (v.to_i > 0)
        end
        raise(ArgumentError, "Unknown permission #{k}") unless @@bits.has_key?(k.to_sym)
        instance_variable_set("@#{k}", true) if v
      end
    else
      # create from integer bit vector
      @@bits.each do |a, v|
        instance_variable_set("@#{a}", (perms & v) != 0 ? true : false)  
      end
    end
  end
  
  # returns bit vector of permissions
  def permissions
    bv= 0
    @@bits.each do |a, v|
      bv |= instance_variable_get("@#{a}") ? v : 0  
    end
    return bv
  end
  
  # shortcut methods
  def any?
    permissions > 0
  end
  
  def to_param
    permissions.to_s
  end
  
  # create a value reader and predicate for each permissions
  @@bits.each do |a, v|
    alias_method((a.to_s + '?').to_sym, a)
  end
end



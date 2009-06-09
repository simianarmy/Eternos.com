# $Id$
# Defined by the ISO 3166-2 standard.  This is a standard that gives short codes
# for provinces, etc. within a country.
# 
# Data is based on http://svn.debian.org/wsvn/pkg-isocodes/trunk/iso-codes/iso_3166/iso_3166_2/iso_3166_2.xml?op=file
# 
# Regions are uniquely identified by their country's alpha 2 code and their
# own country-specific abbrevation.  You can access regions like so:
# 
#   Region['US-CA']   # => #<Region id: 840005, code: "US-CA", country_id: 840, group: nil, name: "California", abbreviation: "CA">
#   Region['AU-NSW']  # => #<Region id: 36001, code: "AU-NSW", country_id: 36, group: nil, name: "New South Wales", abbreviation: "NSW">
# 
# == Identification
# 
# Region ids are based on the country in which they exist suffixed with a 3-digit
# value based on either the order in which they appear in the ISO standard or the
# actual numeric value given to them by the country. 
# 
# == Groups
# 
# Certain countries may have their regions split into different "groups".  Currently,
# the only country that is affected by this is the United Kingdom.  Groups should
# only be important when display a country's regions to the user.
class Region < ActiveRecord::Base
  belongs_to  :country
  has_many    :addresses
  
  validates_presence_of   :name,
                          :country_id,
                          :abbreviation
  validates_length_of     :abbreviation,
                            :within => 1..5
  
#  def initialize(attributes = nil) #:nodoc:
#    super
#    self.abbreviation ||= default_abbreviation unless attributes && attributes.include?(:abbreviation)
#    self.code = default_code
#  end
#  
  private
    # The abbreviation for this region unique within the country
    def default_abbreviation
      "%03d" % (id % 1000) if id
    end
    
    # The unique code assigned to this region by the standard
    def default_code
      "#{country}-#{abbreviation}"
    end
end

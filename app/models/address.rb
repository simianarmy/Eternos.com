# $Id$
# $Id$

# Represents a generic mailing address. Addresses are expected to consist of the
# following fields:
# * +addressable+ - The record that owns the address
# * +street_1+ - The first line of the street address
# * +city+ - The name of the city
# * +postal_code+ - A value uniquely identifying the area in the city
# * +region+ - Either a known region or a custom value for countries that have no list of regions available
# * +country+ - The country, which may be implied by the region
# 
# The following fields are optional:
# * +street_2+ - The second lien of the street address
# 
# There is no attempt to validate the open-ended fields since the context in

# which the addresses will be used is unknown
class Address < ActiveRecord::Base
	belongs_to	:addressable,
								:polymorphic => true
	belongs_to	:region
	belongs_to	:country
	
	alias_attribute :start_at, :moved_in_on
	alias_attribute :end_at, :moved_out_on
	
	attr_accessor :current_address
	
	acts_as_archivable :on => :moved_in_on
	
	include TimelineEvents
	serialize_with_options do
		methods :postal_address, :start_date
	end
	
	# For formatting postal addresses from over 60 countries.
	# Problem: :country must return 2-letter country code for this plugin 
	# to do country-specific formatting. 
	# TODO: monkey-patch plugin
	biggs :postal_address,
		:recipient => Proc.new {|address| address.addressable.try(:full_name) || ""},
		:zip => :postal_code,
		:street => [:street_1, :street_2],
		:state => Proc.new {|address| address.region.name },
		:country => Proc.new {|address| address.country.name }
	
	with_options :if => :validatible_location do |m|
		m.validates_presence_of :street_1
		m.validates_presence_of :city
		m.validates_presence_of :country_id, :on => :create
		m.validates_presence_of :region_id, :if => :known_region_required?

##	validates_presence_of :custom_region,
##													:message => 'Custom Region!?',
##													:if => :custom_region_required?
		m.before_save :ensure_exclusive_references
	end
	
	before_save :clear_moved_out_if_current_address
	
	# Why was this added - duplicates above code??
	# validate :if => :validatible_location do |address|
	#			address.errors.add("", "Please enter a street address") if address.street_1.blank?
	#			address.errors.add("", "Please select a country") if address.country_id.blank?
	#			address.errors.add("", "Please enter a city name") if address.city.blank?
	#			address.errors.add("", "Postal code not a number") unless address.postal_code.to_s =~ /\A[+-]?\d+\Z/
	#		end
	
	LocationTypes = {
		'Home' => 'home',
		'Birth' => 'birth',
		'Business' => 'business',
		'Billing' => 'billing'
		}.freeze
	
	Home = LocationTypes['Home']
	Birth = LocationTypes['Birth']
	Business = LocationTypes['Business']
	Billing = LocationTypes['Billing']
	DefaultLocationType = Home
	
	named_scope :home, :conditions			=> {:location_type => Home}
	named_scope :business, :conditions	=> {:location_type => Business}
	named_scope :billing, :conditions		=> {:location_type => Billing}
	named_scope :birth, :conditions			=> {:location_type => Birth}
	# TODO: use acts_as helper
	named_scope :in_dates, lambda { |start_date, end_date|
		{
			:conditions => ["(moved_in_on >= ? AND moved_out_on <= ?) OR " +
				"(moved_out_on IS NULL AND moved_in_on <= ? AND DATE(NOW()) > ?)",
				start_date, end_date,
				end_date, start_date]
			}
		}
	# Returns true if address location is one that needs validation
	def validatible_location
		location_type != Birth
		#false
	end
	
	# Returns the country, which may be determined from the
	# current region
	def country_with_region_check
		region ? region.country : country_without_region_check
	end
	alias_method_chain :country, :region_check
	
	# Gets the name of the region that this address is for (whether it is a custom or
	# known region in the database)
	def region_name
		custom_region || region && region.name
	end
	
	# Gets all regions for existing country
	def regions
		ignore_nil { country.regions }
	end
	
	# Helper for form selects
	#def country_id
	#	 country.id if country
	#end
	
	# Gets a representation of the address on a single line.
	# 
	# For example,
	#		address = Address.new
	#		address.single_line			# => ""
	#		
	#		address.street_1 = "1600 Amphitheatre Parkey"
	#		address.single_line			# => "1600 Amphitheatre Parkway"
	#		
	#		address.street_2 = "Suite 100"
	#		address.single_line			# => "1600 Amphitheatre Parkway, Suite 100"
	#		
	#		address.city = "Mountain View"
	#		address.single_line			# => "1600 Amphitheatre Parkway, Suite 100, Mountain View"
	#		
	#		address.region = Region['US-CA']
	#		address.single_line			# => "1600 Amphitheatre Parkway, Suite 100, Mountain View, California, United States"
	#		
	#		address.postal_code = '94043'
	#		address.single_line			# => "1600 Amphitheatre Parkway, Suite 100, Mountain View, California	 94043, United States"
	def single_line
		multi_line.join(', ')
	end
	
	# Gets a representation of the address on multiple lines.
	# 
	# For example,
	#		address = Address.new
	#		address.multi_line			# => []
	#		
	#		address.street_1 = "1600 Amphitheatre Parkey"
	#		address.multi_line			# => ["1600 Amphitheatre Parkey"]
	#		
	#		address.street_2 = "Suite 100"
	#		address.multi_line			# => ["1600 Amphitheatre Parkey", "Suite 100"]
	#		
	#		address.city = "Mountain View"
	#		address.multi_line			# => ["1600 Amphitheatre Parkey", "Suit 100", "Mountain View"]
	#		
	#		address.region = Region['US-CA']
	#		address.multi_line			# => ["1600 Amphitheatre Parkey", "Suit 100", "Mountain View, California", "United States"]
	#		
	#		address.postal_code = '94043'
	#		address.multi_line			# => ["1600 Amphitheatre Parkey", "Suit 100", "Mountain View, California	94043", "United States"]
	def multi_line
		lines = []
		lines << street_1 if street_1?
		lines << street_2 if street_2?
		
		line = ''
		line << city if city?
		if region_name
			line << ', ' unless line.blank?
			line << region_name
		end
		if postal_code?
			line << '	 ' unless line.blank?
			line << postal_code
		end
		lines << line unless line.blank?
		
		lines << country.name if country
		lines
	end
	
	# Virtual attribute
	def current_address=(val)
	  @current_address = (val && val == '1')
	end
	
  private
  # Does the current country have a list of regions to choose from?
  def known_region_required?
    validatible_location && country && country.regions.any?
  end

  # A custom region name is required if a known region was not specified and
  # the country in which this address resides has no known regions in the
  # database
  def custom_region_required?
    !region_id && country && country.regions.empty?
  end

  # Ensures that the country id/user region combo is not set at the same time as
  # the region id
  def ensure_exclusive_references
    if known_region_required?
      self.country_id = nil
      self.custom_region = nil
    end
    true
  end
  
  def clear_moved_out_if_current_address
    self.moved_out_on = nil if @current_address
  end
end



# $Id$

class AddressBook < ActiveRecord::Base
  belongs_to :user
  has_many  :addresses, :as => :addressable
  has_many :phone_numbers, :as => :phoneable, :dependent => :destroy
 
  validate :validate_name
  #validates_associated :addresses, :message => nil, :on => :update
  #validates_associated :phone_numbers, :message => nil, :on => :update
  encrypt_attributes
  
  include Addressable

  after_update :save_associations
  
  NAME_TITLES = %w[ Mr. Ms. Mrs. Miss Dr. Sir ]
  NAME_SUFFIXES = %w[ Jr. Sr. II III IV M.D. P.H.D. P.E. ]
  
  # Associated validation errors are not displayed properly, fix them here
  def after_validation
    # Iterate through the errors
    errors.each do |field,message|
      # If the field of an error is really an association, then the 'validates_associated' found an error
      if self.class.reflect_on_all_associations.collect(&:name).index(field.to_sym)
        # Iterate through the objects in the association looking for the invalid ones
        for association in [self.send(field)].flatten
          if association and !association.valid?
            # add the error messages of the associated object to my error messages
            association.errors.each do |field,msg|
              unless self.errors.include?(field)
                self.errors.add(field, msg)
              end
            end
          end
        end
      end
    end
  end

  # Checks associations for validity, weird but necessary since we are not 
  # using traditional error_message_for object, assoc1, assoc2 format
  # def valid_associations?
  #     addresses.first.valid? && 
  #     !phone_numbers.map(&:valid?).include?(false)
  #   end
  
  def validate_name
    if first_name.blank? or last_name.blank?
      errors.add('name', "Please enter First and Last Name")
    end
  end
  
  # Returns home address or builds new address object with home location type
  def home_address
    addresses.home.first || addresses.build(:location_type => Address::Home)
  end
  
  def billing_address
    addresses.billing.first || addresses.build(:location_type => Address::Billing)
  end
  
  def full_name
    returning String.new do |name|
      name << name_title << ' ' unless name_title.blank?
      name << first_name.capitalize
      name << ' ' + middle_name.first.upcase + '.' unless middle_name.blank?
      name << ' ' + last_name.capitalize
      name << ", #{name_suffix}" unless name_suffix.blank?
    end
  end
  
  def sync_with_facebook(fb_user, fb_info)
    # fb_info hash data 
    self.first_name    = fb_info[:first_name]  unless fb_info[:first_name].blank?
    self.last_name     = fb_info[:last_name]   unless fb_info[:last_name].blank?
    self.gender        = fb_info[:sex]         unless fb_info[:sex].blank?
    self.birthdate     = fb_info[:birthday]    unless fb_info[:birthday].blank?
    # Facebooker fb_user object data
    if loc = fb_user.current_location
      logger.debug "FacebookUser.current_location = #{loc.inspect}"
      sync_with_facebook_location(Address::Home, loc)
    end
    if loc = fb_user.hometown_location
      logger.debug "FacebookUser.hometown_location = #{loc.inspect}"
      sync_with_facebook_location(Address::Birth, loc)
    end
    save!
  end
    
  private
  
  # after_update callback for associations
  def save_associations
    phone_numbers.each do |pn|
      pn.save
    end
    addresses.each do |addr|
      # Don't save bad updates b/c they won't get caught
      begin
        addr.save!
      rescue
        self.errors.add('address', "Invalid address")
      end
    end
  end
  
  # sync_with_facebook helper takes Facebooker::Location object
  def sync_with_facebook_location(location, fb_location)
    # Always create - ignore errors if already exists
    attrs = {:location_type => location, :city => fb_location.city, :postal_code => fb_location.zip.to_s}
    begin
      # Lookup country & state by full-name 
      if fb_location.state && region = Region.find_by_name(fb_location.state)
        attrs[:region_id] = region.id
        attrs[:country_id] = region.country.id
      elsif fb_location.country && country = Country.find_by_name(fb_location.country)
        attrs[:country_id] = country.id
      end
      # If we could not lookup the state or country from the facebook hash, we need to 
      # use a default
      attrs[:country_id] ||= default_region.country.id
      # Find by location object attributes first otherwise we will end up with duplicates
      addresses.build(attrs.merge(:no_street => true)) unless addresses.find(:first, :conditions => attrs)
    rescue Exception => e
      logger.warn "AddressBook.sync_with_facebook_location address create error: #{e}"
    end
  end

  # Default region for user.  Ideally it would be the user's country by Geolocation
  def default_region
    if home = addresses.home.first
      home.region
    else
      Region.find_by_name('Washington')
    end
  end
end

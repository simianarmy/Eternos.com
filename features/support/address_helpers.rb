# $Id$

module AddressHelpers
  def fill_address_fields(prefix)
    fill_in "#{prefix}_address_street_1", :with => Faker::Address.street_address
    fill_in "#{prefix}_address_street_2", :with => Faker::Address.street_address
    fill_in "#{prefix}_address_city", :with => Faker::Address.city
    fill_in "#{prefix}_address_country", :with => "840" # US
    fill_in "#{prefix}_address_region", :with => "4163" # WA
    fill_in "#{prefix}_address_postal_code", :with => Faker::Address.zip_code
  end
  
  def fill_phone_fields(type, prefix)
    prefix += '_new_phone_number_attributes_'
    select type.capitalize, :from => "#{prefix}_phone_type"
    fill_in "#{prefix}_area_code", :with => "206" # Represent!
    fill_in "#{prefix}_number", :with => "123-4567"
  end
end

World(AddressHelpers)
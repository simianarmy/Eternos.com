# $Id$
#
# Custom module for addressable ActiveRecord classes

# Mixin providing helper methods for classes using polymorphic address class

module Addressable
  # Create or update address from params
  def address_attributes=(attr)
    attr.symbolize_keys!
    if attr[:id].blank?
      attr.merge!(:addressable => self)
      attr[:location_type] ||= Address::DefaultLocationType
      respond_to?(:addresses) ? addresses.build(attr) : build_address(attr)
    else
      id = attr.delete(:id).to_i
      if respond_to?(:addresses)
        a = addresses.detect { |addr| addr.id == id }
      else
        a = address
      end
      # If updating from region to country, we must manually disable region field
      if attr[:region_id].blank? && !attr[:country_id].blank?
        a.region_id = nil
      end
      a.attributes = attr
    end
  end

  # Create or update phone number from params
  def new_phone_number_attributes=(phone_attributes)
    phone_attributes.each do |attributes|
      #attributes.merge!(:phoneable_id => self.id, :phoneable_type => self.class.to_s)
      phone_numbers.build(attributes.merge(:phoneable => self))
    end
  end
  
  def existing_phone_number_attributes=(phone_attributes)
    phone_numbers.reject(&:new_record?).each do |phone_number|
      attributes = phone_attributes[phone_number.id.to_s]
      if attributes
        phone_number.attributes = attributes
      else
        phone_numbers.delete(phone_number)
      end
    end
  end
end

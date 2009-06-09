# $Id$
module AddressesHelper
  # Confused myself with this...For Address country & region dynamic selects
  # What is this for?
  def valid_for_select(address)
    !address.nil? && !address.new_record?
  end
  
  def valid_for_region_select(address)
    valid_for_select(address) && address.region
  end
  
  # Fetches appropriate regions for address form select
  def address_regions(address)
    return [] unless address
    
    if address.new_record? && address.country_id
      Region.find_all_by_country_id(address.country_id)
    elsif address.region
      address.regions
    else
      []
    end
  end
  
  def add_phone_number_link(name, owner, div = :phone_numbers)
    link_to_function(name) do |page| 
      page.insert_html :bottom, div, :partial => 'shared/phone_number', 
        :locals => {:owner => owner, :phone_number => PhoneNumber.new, :phone_number_counter => 1}
    end
  end
  
  # Displays inputs for adding/editing phone numbers in a form
  # Takes model object that has_a :address_book
  def form_for_phone_numbers(id, field, phone_numbers)
    phone_numbers << PhoneNumber.new if phone_numbers.empty?

    out = content_tag(:div, :id => id) do 
      render(:partial => 'shared/phone_number', :collection => phone_numbers, :locals => {
        :owner => field})
    end
    out << add_phone_number_link("Add a phone number", field, id)
  end
end

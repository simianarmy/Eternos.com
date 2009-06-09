# $Id$
module MemberDetailsSpecHelper
  def create_name_attributes
    {:first_name => 'shit',
     :last_name => 'head'
     }
  end

  def create_address_attributes
    { :address => {:street_1 => 'street', :city => 'Seattle', :postal_code => '666', 
      :country_id=>'20', :region_id =>'1', :location_type => Address::Home}}
  end
  
  def create_new_phone_number_attributes
    {:new_phone_number_attributes => [{:area_code => '206', :number => '555-5555', 
      :phone_type=>PhoneNumber::PhoneTypes['Home']}]}
  end
  
  def create_existing_phone_number_attributes
    {:existing_phone_number_attributes => {:area_code => '206', :number => '555-5555'}}
  end
  
  def new_member_details_attributes
    create_name_attributes.merge(create_address_attributes).
      merge(create_new_phone_number_attributes)
  end
end

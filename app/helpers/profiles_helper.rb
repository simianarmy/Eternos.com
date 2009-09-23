module ProfilesHelper
  def add_address_link(name, div, parent_obj, form_name, location=Address::Home, obj=Address.new)
    link_to_function(name) do |page|
      page.insert_html :bottom, div, :partial => "addresses/address", 
        :locals => { :parent_object => parent_obj, :addressable => form_name, 
          :location => location, :address => obj }
    end
  end
  
  def add_job_link(name, owner)
    link_to_function(name) do |page|
      page.insert_html :bottom, :careers, :partial => "profiles/career", 
        :object => Job.new
    end
  end
  
  def add_school_link(name, owner)
    link_to_function(name) do |page|
      page.insert_html :bottom, :education, :partial => "school", 
        :object => School.new
    end
  end
end

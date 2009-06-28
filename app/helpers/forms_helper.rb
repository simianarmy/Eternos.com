# $Id$

module FormsHelper
  
  def user_session
    @user_session ||= UserSession.new
  end
  
  def form_for_using_ssl(record_or_name_or_array, *args, &block)
    options = args.extract_options!
    options[:url] ||= {}
    options[:url].merge!(:protocol => 'https', :only_path => false)
    args << options  
    form_for(record_or_name_or_array, *args, &block)
  end
  
  # Template helper for generic forms
  def form_field_with_label(form, field, options={})
    render :partial => 'forms/field',
        :locals => { :element => form.text_field(field, options),
          :label => form.label(field, options[:label])
          }
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
  
  def fields_for_phone_number(phone, owner, *args, &block)
    fields_for_association('phone_number', phone, owner, *args, &block)
  end
  
  def fields_for_job(job, owner, *args, &block)
    fields_for_association('career', job, owner, *args, &block)
  end
  
  def fields_for_school(school, owner, *args, &block)
    fields_for_association('school', school, owner, *args, &block)
  end
  
  private
  
  def fields_for_association(name, object, parent, *args, &block)
    prefix = object.new_record? ? 'new' : 'existing'
    fields_for("#{parent}[#{prefix}_#{name}_attributes][]", object, *args, &block)
  end
end
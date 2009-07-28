# $Id$

class Profile < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  
  with_options :dependent => :destroy do |m|
    m.has_many :addresses, :as => :addressable
    m.has_many :careers, :class_name => 'Job'
    m.has_many :schools
    m.has_many :medicals
    m.has_many :medical_conditions
    m.has_many :families
    m.has_many :feed_urls
    m.has_many :contact_emails
    m.has_one :facebook_content
  end
  
  validates_existence_of :member, :message => 'Could not find the owner of this profile'
  validates_associated :careers, :message => 'Some required career fields are missing'
  validates_associated :schools, :messages => 'Some required education fields are missing'
  
  serialize :facebook_data
  xss_terminate :except => [ :facebook_data ]
    
  include Addressable
  after_update :save_associations
    
  def birth_address
    addresses.find_birth(:first) || addresses.build(:location_type => Address::Birth)
  end
  
  def marshal_data
    [Marshal.dump(string)].pack('m*')
  end
  
  def unmarshal
    Marshal.load(str.unpack("m")[0])
  end

  private
  
  def save_associations
    (addresses+careers+schools).each do |ass|
      begin
        ass.save!
      rescue
        self.errors.add_to_base(ass.errors.full_messages)
      end
    end
  end
  
  # Create or update careers from params
  def new_career_attributes=(job_attributes)
    new_association_attributes_helper(job_attributes, careers)
  end
  
  def existing_career_attributes=(job_attributes)
    existing_association_attributes_helper(job_attributes, careers)
  end
  
  # Create or update education from params
  def new_school_attributes=(school_attributes)
    new_association_attributes_helper(school_attributes, schools)
  end
  
  def existing_school_attributes=(school_attributes)
    existing_association_attributes_helper(school_attributes, schools)
  end
  
  private
  
  def new_association_attributes_helper(attributes, association)
    attributes.each_value do |attr|
      association.build(attr)
    end
  end
  
  def existing_association_attributes_helper(attributes, association)
    association.reject(&:new_record?).each do |obj|
      attr = attributes[obj.id.to_s]
      if attr
        obj.attributes = attr
      else
        association.delete(obj)
      end
    end
  end
end

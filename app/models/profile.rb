# $Id$

class Profile < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'user_id'
  
  # virtual attribute
  attr_accessor :cellphone 
  
  with_options :dependent => :destroy do |m|
    m.has_many :careers, :class_name => 'Job'
    m.has_many :schools
    m.has_many :medicals
    m.has_many :medical_conditions
    m.has_many :families
    m.has_many :relationships
    m.has_one :facebook_content
    m.has_attached_file :photo
  end
  
  validates_associated :careers, :message => 'Some required career fields are missing'
  validates_associated :schools, :messages => 'Some required education fields are missing'
  
  serialize :facebook_data
  xss_terminate :except => [ :facebook_data ]
    
  include Addressable
  after_update :save_associations
  
  def duration_associations
    [careers, families, medical_conditions, relationships, schools].compact
  end
  
  # Returns associations in hash that fall within specified date range  
  def timeline(starting, ending)
    {
    :careers            => careers.in_dates(starting, ending),
    :education          => schools.in_dates(starting, ending)
    }
  end
  
  def birth_address
    addresses.find_birth(:first) || addresses.build(:location_type => Address::Birth)
  end
  
  def marshal_data
    [Marshal.dump(string)].pack('m*')
  end
  
  def unmarshal
    Marshal.load(str.unpack("m")[0])
  end

  FIELDS = [:status, :political, :pic_small, :name, :quotes, :is_app_user, :tv, :profile_update_time, 
     :meeting_sex, :hs_info, :timezone, :relationship_status, :hometown_location, :about_me, :wall_count, 
     :significant_other_id, :pic_big, :music, :work_history, :sex, :religion, :notes_count, :activities, 
     :pic_square, :movies, :has_added_app, :education_history, :birthday, :birthday_date, :first_name, 
     :meeting_for, :last_name, :interests, :current_location, :pic, :books, :affiliations, :locale, 
     :profile_url, :proxied_email, :email_hashes, :allowed_restrictions, :pic_with_logo, :pic_big_with_logo, 
     :pic_small_with_logo, :pic_square_with_logo]
      
  def sync_with_facebook(fb_user, fb_info)
    self.political_views  = fb_info[:political] unless fb_info[:political].blank?
    self.religion         = fb_info[:religion] unless fb_info[:religion].blank?
    self.facebook_data    = fb_info
    
    sync_career_from_facebook(fb_user.work_history) if fb_user.work_history.any?
    sync_education_from_facebook(fb_user.education_history) if fb_user.education_history.any?
    # if fb_info[:pic].any? && !self.photo
    #       TempFile.new(File.basename(fb_info[:pic])) do |tmp|
    #         rio(fb_info[:pic]).binmode > rio(tmp.path)
    #         photo = tmp
    #       end
    #       tmp.close
    #     end
    save
  end
    
  protected
    
  def save_associations
    (careers+schools).each do |ass|
      begin
        ass.save!
      rescue
        self.errors.add_to_base(ass.errors.full_messages)
        false
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
  
  # Takes Facebooker::WorkInfo array
  def sync_career_from_facebook(fb_work_info)
    begin
      logger.debug "Importing #{fb_work_info.size} facebook jobs: #{fb_work_info.inspect}"    
      fb_work_info.each do |wi|
        attrs = Job.attributes_from_fb(wi).symbolize_keys
        careers.build(attrs) unless careers.find_by_company_and_title(attrs[:company], attrs[:title])  
      end
    rescue Exception => e
      logger.error "Exception synching career from Facebook: " + e.backtrace.to_s
    end
  end
  
  # Takes Facebooker::EducationInfo array
  def sync_education_from_facebook(education_info)
    begin
      logger.debug "Importing #{education_info.size} facebook education: #{education_info.inspect}"    
      education_info.each do |wi|
        attrs = School.attributes_from_fb(wi).symbolize_keys
        schools.build(attrs) unless schools.find_by_name(attrs[:name])
      end
    rescue Exception => e
      logger.error "Exception synching education from Facebook: " + e.backtrace.to_s
    end
  end
  
end

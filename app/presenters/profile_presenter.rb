# $Id$

# TODO: Remove some duplication with SetupPresenter

class ProfilePresenter < Presenter
  delegate :phone_numbers, :to => :address_book
  delegate :gender, :height, :weight, :race, :religion, :political_views, 
  :sexual_orientation, :nickname, :ethnicity, :children, 
  :birth_address, :careers, :schools, :to => :profile
  
  attr_accessor :address_book, :profile, :new_address_book, :new_profile, 
    :security_questions,
  :address, :addresses,
  :job, :jobs,
  :school, :schools,
  :medical, :medicals,
  :medical_condition, :medical_conditions,
  :family, :families,
  :relationship, :relationships,
  :errors, :params

  def initialize(user, fb_session, params)
    @user = user
    @fb_session = fb_session
    @params = params
  end

  def address_book
    @address_book ||= @user.address_book
  end

  def profile
    @profile ||= @user.profile
  end

  def security_questions
    @security_questions ||= @user.security_questions
  end
  
  def load_personal_info
    @address_book = address_book
    @profile  = profile
  end

  def update_personal_info
    @new_address_book = params[:address_book]
    @new_profile = params[:profile]
    @errors = []

    unless @profile.update_attributes(@new_profile)
      @errors = @profile.errors.full_messages
      return false
    end
    unless @address_book.update_attributes(@new_address_book)
      @errors = @address_book.errors.full_messages
    end
    @errors.empty?
  end

  def has_required_personal_info_fields?
    (ab = @address_book) &&
    !ab.first_name.blank? && !ab.last_name.blank? && ab.birthdate
  end

  def load_history
    find_address
    find_job
    find_school
    find_medical
    find_medical_condition
    find_family
    find_relationship
    @address = Address.new
    @job = Job.new
    @school = School.new
    @medical = Medical.new
    @medical_condition = MedicalCondition.new
    @family = Family.new
    @relationship = Relationship.new
  end

  def find_address
    @addresses = address_book.addresses
  end

  def find_job
    @jobs = profile.careers
  end

  def find_school
    @schools = profile.schools
  end

  def find_medical
    @medicals = profile.medicals
  end

  def find_medical_condition
    @medical_conditions = profile.medical_conditions
  end

  def find_family
    @families = profile.families
  end

  def find_relationship
    @relationships = @user.relationships
  end

  ### OLDER O.G. CODE
  #
  # Tricky - this is built in address model using mass-assignment from form values.
  # But if not valid, no way to retrieve it from address_book it address_book not saved.
  # address_book.home_address = not found
  # Work around by fetching most recently built (not saved) address
  # TODO: Look into using after_initialize callback
  def home_address
    @address ||= address_book.home_address
    @address ||= address_book.addresses.detect {|addr| addr.new_record?}
  end

  def save(params)
    personal_saved = profile_saved = true

    begin
      personal_saved = address_book.update_attributes(params[:address_book]) if params[:address_book]
      profile_saved = profile.update_attributes(params[:profile]) if params[:profile]
    rescue
      personal_saved = false
    end

    unless personal_saved && profile_saved
      detect_and_combine_errors(address_book, profile) 
      false
    else
      true
    end
  end
  ### END OLDER CODE
end

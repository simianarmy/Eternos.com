# $Id$

class ProfilePresenter < AccountPresenter
  delegate :gender, :height, :weight, :race, :religion, :political_views, 
  :sexual_orientation, :nickname, :ethnicity, :children, 
  :birth_address, :careers, :schools, :to => :profile
  
  attr_accessor :address, :addresses,
  :job, :jobs,
  :school, :schools,
  :medical, :medicals,
  :medical_condition, :medical_conditions,
  :family, :families,
  :relationship, :relationships

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

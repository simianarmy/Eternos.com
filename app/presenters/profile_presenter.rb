# $Id$

class ProfilePresenter < Presenter
  attr_accessor :address_book, :profile
  delegate :phone_numbers, :to => :address_book
  delegate :gender, :height, :weight, :race, :religion, :political_views, 
    :sexual_orientation, :nickname, :ethnicity, :children, 
    :birth_address, :careers, :schools, :to => :profile
  
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
  
end

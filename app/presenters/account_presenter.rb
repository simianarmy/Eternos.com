# $Id$

class AccountPresenter < Presenter
  @@NumSecurityQuestions = 2
  
  delegate :phone_numbers, :to => :address_book
  attr_accessor :address_book, :profile, :new_address_book, :new_profile, :security_questions,
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
    @security_questions = security_questions
    (0..@@NumSecurityQuestions-1).each do |i|
      @security_questions[i] ||= @user.security_questions.new
    end
  end
  
  def update_personal_info
    @new_address_book = params[:address_book]
    @new_profile = params[:profile]
    @errors = []
    
    unless @profile.update_attributes(@new_profile)
      @errors = @profile.errors.full_messages
    end
    unless @address_book.update_attributes(@new_address_book)
      @errors = @address_book.errors.full_messages
    end
    # Save security questions
    @user.update_attributes(params[:user])
    unless @user.security_questions.all?(&:valid?)
      @errors = @user.security_questions.collect(&:errors).map(&:full_messages).uniq
    end
    @errors.empty?
  end
   
  def has_required_personal_info_fields?
     (ab = @address_book) &&
     !ab.first_name.blank? && !ab.last_name.blank? && ab.birthdate
     # && (@user.security_questions.size == @@NumSecurityQuestions)
  end
end


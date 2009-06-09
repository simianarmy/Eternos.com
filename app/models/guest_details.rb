# $Id$
# model for guest info that doesn't fit nicely in User model
#
class GuestDetails
  attr_accessor :first_name, :last_name, :email
  attr_reader :login, :errors
  
  def initialize(attributes={})
    @first_name = ignore_nil {attributes[:address_book][:first_name]}
    @last_name = ignore_nil {attributes[:address_book][:last_name]}
    @login = @email = ignore_nil {attributes[:email]}
    @errors = []
    @phone_numbers = []
  end
  
  def valid?
    @errors.clear
    if @first_name.blank? or @last_name.blank?
      @errors << "First and Last Name Required"
    end
    addr = EmailVeracity::Address.new(@email)
    unless addr.valid?
      @errors << "Invalid email address"
    end
    @errors.empty?
  end
end
    
  

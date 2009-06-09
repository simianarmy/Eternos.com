# $Id$
class AddressBooksController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  def index
    @address_book = AddressBook.find_or_initialize_by_user_id(current_user.id)
  end
  
  def create
    @address_book = AddressBook.new(params[:member_detail]) 
    @address_book.user = current_user
    
    if @address_book.save
      flash[:notice] = "Details saved successfully"
      redirect_to member_details_url
    else
      render :action => "index"
    end
  end
  
  def update
    if ignore_nil { params[:address_book][:existing_phone_number_attributes] }
      params[:address_book][:existing_phone_number_attributes] ||= {}
    end
    
    @address_book = current_user.address_book
    if @address_book.update_attributes(params[:address_book])
      flash[:notice] = "Successfully Updated"
      redirect_to member_details_url
    else
      render :action => 'index'
    end
  end
end

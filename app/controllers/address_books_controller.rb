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
    begin
      if params[:address_book][:existing_phone_number_attributes]
        params[:address_book][:existing_phone_number_attributes] ||= {}
      end
    end
    @address_book = current_user.address_book
    
    respond_to do |format|
      if @address_book.update_attributes(params[:address_book])
        flash[:notice] = "Address Book succesfully updated"
        format.html { 
          redirect_to member_details_url
        }
        format.js
      else       
        format.html {
          render :action => 'index'
        }
        format.js {
          flash[:error] = @address_book.errors.full_messages.join('<br/>')
        }
      end
    end
  end
end

# $Id$
class GuestsController < ApplicationController
  before_filter :login_required
  require_role "Member"
  
  def index
    @guests = current_user.loved_ones
    @invitation = current_user.guest_invitations.new
    @invitations = current_user.guest_invitations.unconfirmed
  end
  
  def create
    @guest = Guest.new(params[:guest])
    @guest.current_host_id = current_user.id
    
    # Validate relationship param - selected or new
    @guest.circle = if !params[:guest][:new_circle_name].blank?
      Circle.find_or_create_by_name(:name => params[:guest][:new_circle_name],
        :user_id => current_user.id)
      elsif !params[:guest][:circle_id].blank?
        Circle.find(params[:guest][:circle_id])
      end
    
    # Validate phone numbers
    if params[:guest][:address_book]
      ab_attrs = params[:guest][:address_book].merge({
          :first_name => params[:guest][:first_name],
          :last_name => params[:guest][:last_name]
      })
      # Address book needs valid full name
      @guest.build_address_book(ab_attrs)
    end
    
    respond_to do |format|
      if @guest.save
        flash[:notice] = 'Guest successfully added.'
    
        format.html {
          redirect_to guests_path
        }
        format.js {
          render :update do |page|
            page.hide :new_guest
            page.replace_html :bottom, :guests, :partial => 'index_item', :object => @guest
          end
        }
      else
        format.html {
          @guests = current_user.loved_ones
          render :action => 'index'
        }
        format.js {
          flash[:error] = @guest.errors.full_messages
          render :update do |page|
            page.flash_and_fade
            flash.discard
          end
        }
      end
    end
  end
  
  def show
    @guest = current_user.loved_ones.find(params[:id])
    @guest.current_host_id = current_user.id
  end
  
  def update
    @guest = current_user.loved_ones.find(params[:id])
    @guest.current_host_id = current_user.id
    
    # Handle user-created circles
    if !params[:guest][:new_circle_name].blank?
      @guest.circle_id = Circle.find_or_create_by_name(:name => params[:guest][:new_circle_name], 
        :user_id => current_user.id).id
    end
    # Work around nested models limitation
    if params[:guest][:address_book]
      # Validate or not...we might want to allow partial info
      @guest.address_book.update_attributes(params[:guest][:address_book])
    end
    
    respond_to do |format|
      if @guest.update_attributes(params[:guest])
        flash[:notice] = "Successfully updated guest"
        format.html {
          redirect_to guests_path
        }
        format.js
      else
        flash[:error] = "Error updating guest"
        format.html {
          render :action => 'show'
        }
        format.js
      end
    end
  end
  
  def destroy
    @guest = current_user.loved_ones.find(params[:id])
    @guest.destroy
    flash[:notice] = "Successfully destroyed guest"
    redirect_to guests_url
  end
end

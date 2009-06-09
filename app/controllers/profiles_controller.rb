# $Id$

class ProfilesController < ApplicationController
  before_filter :login_required
  require_role "Member"

  def show
    @profile = get_profile
    if params[:tab]
      render :layout => false, :action => params[:tab]
    end
  end
    
  def update
    if ignore_nil { params[:address_book][:existing_phone_number_attributes] }
      params[:address_book][:existing_phone_number_attributes] ||= {}
    end
    
    @profile = get_profile
    
    respond_to do |format|
      if @profile.save(params)
        flash[:notice] = "Profile updated."
        format.html {
          redirect_to profiles_url
        }
        format.js
      else
        format.html { render :action => 'index' }
        format.js {
          flash[:error] = @profile.errors.full_messages
        }
      end
    end
  end
  
  private
  def get_profile
    ProfilePresenter.new(:address_book => current_user.address_book.nil? ? 
      current_user.build_address_book : current_user.address_book,
      :profile => current_user.profile.nil? ? current_user.build_profile : current_user.profile)
  end
end

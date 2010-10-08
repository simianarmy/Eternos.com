class UnsubscribeController < ApplicationController
  layout 'public_notabs'

  def show
    @email = EmailBlacklist.new
  end

  def create
    address = params[:email] || params[:email_blacklist][:email]
    @email = EmailBlacklist.new(:email => address)
    
    respond_to do |format|
      format.html {
        # Make sure this is an existing email address to prevent hacking
        # Don't raise error if email already in blacklist, just confirm success
        if !@email.email.blank? && 
          (EmailBlacklist.find_by_email(@email.email) || User.email_eq(@email.email).empty?)
          # Do not warn if no match - pretend like it succeeded
        elsif not @email.save
          flash[:error] = 'Error unsubscribing: ' + @email.errors[:email]
          render :action => 'show'
        end
      }
    end
  end

end
class FbController < ApplicationController
  #layout false
  def index
  end
  
  def show
    @notify_email = NotifyEmail.new(params[:notify_email])
  end
  
  def create
    @notify_email = NotifyEmail.new(params[:notify_email])
    
    if @notify_email.save
      flash[:notice] = "Email saved"
    else
      render :action => :show
    end
  end
end

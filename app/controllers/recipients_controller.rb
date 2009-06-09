# $Id$
class RecipientsController < ApplicationController
  def index
    @recipients = Recipient.find(:all)
  end
  
  def show
    @recipient = Recipient.find(params[:id])
  end
  
  def new
    @recipient = Recipient.new
  end
  
  def create
    @recipient = Recipient.new(params[:recipient])
    if @recipient.save
      flash[:notice] = "Successfully created recipient."
      redirect_to @recipient
    else
      render :action => 'new'
    end
  end
  
  def edit
    @recipient = Recipient.find(params[:id])
  end
  
  def update
    @recipient = Recipient.find(params[:id])
    if @recipient.update_attributes(params[:recipient])
      flash[:notice] = "Successfully updated recipient."
      redirect_to @recipient
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @recipient = Recipient.find(params[:id])
    @recipient.destroy
    flash[:notice] = "Successfully destroyed recipient."
    redirect_to recipients_url
  end
end

class PrelaunchController < ApplicationController
  def index
    @notify_email = NotifyEmail.new(params[:notify_email])
    @notify_email.keywords ||= params[:keywords].join('~') if params[:keywords]
    @notify_email.referrer ||= request.referer
    @hide_login_box = @hide_footer = true
  end
  
  def create
    @notify_email = NotifyEmail.new(params[:notify_email])
    
    if @notify_email.save
      flash[:notice] = "Email saved, thank you for your interest!"
      #redirect_to root_path
    end
    @hide_login_box = @hide_footer = true
    render :action => :index
  end
  
end

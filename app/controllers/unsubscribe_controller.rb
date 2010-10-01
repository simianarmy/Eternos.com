class UnsubscribeController < ApplicationController
  layout 'mementos_show'
  before_filter {|controller| controller.instance_variable_set('@is_unsubscribe',true) }

  def show
    @email = EmailBlacklist.new
  end

  def create
    @email = EmailBlacklist.new(:email => params[:email_blacklist][:email])
    if @email.save
      redirect_to :action => 'save'
    else
      flash[:error] = 'Error in e-mail: ' + @email.errors[:email]
      return render('show')
    end
  end

  def save
  end
  
end
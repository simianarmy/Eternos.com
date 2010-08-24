# $Id$
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    #if user.email_registration_required?
    #unless Rails.env == 'test'
      spawn(:method => :thread) do
        UserMailer.deliver_signup_notification(user) 
      end
    #end
  end

  # $Author$
  # This doesn't really make sense to check after every save - moved into user model.
  # def after_save(user)
  #     UserMailer.deliver_activation(user) if user.recently_activated?
  #   end
end

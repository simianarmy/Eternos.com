# $Id$
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    # Confusing...disabling check until more tests are in place
    if user.email_registration_required?
      spawn(:method => :thread) do
        UserMailer.deliver_signup_notification(user) 
      end
    end
  end

end

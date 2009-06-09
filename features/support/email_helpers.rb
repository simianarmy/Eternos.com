# $Id$

module EmailHelpers
  def current_email_address
    @email || (@current_user && @current_user.email) || "foo@bar.com"
  end
end
World(EmailHelpers)
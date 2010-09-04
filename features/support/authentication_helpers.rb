# $Id$

module UserHelpers
  def login
    user
    login_as user
  end
  
  def login_as(user)
    login_with_credentials user.email, user.password
    response.should contain("Welcome, #{user.name}")
    @current_user = user
  end
  
  def login_with_credentials(login, password)
    visit path_to("the homepage")
    response.should contain("Signup for secure")
    click_button "login"
    fill_in "username", :with => login
    fill_in "password-created2", :with => password
    click_button "login_button"
  end
  
  def log_out
    get logout_path
    @current_user = nil
  end
  
  def user
    (@current_user || @me) || create_member
  end
  
end

World(UserHelpers)
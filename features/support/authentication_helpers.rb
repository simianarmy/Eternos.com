# $Id$

module UserHelpers
  def login_as(user)
    visit new_session_path
    fill_in "login", :with => user.email
    fill_in "password", :with => user.password
    click_button
    response.should contain("Welcome, #{user.name}")
    @current_user = user
  end
  
  def log_out
    get logout_path
    @current_user = nil
  end
  
  def user
    @current_user || @me
  end
end

World(UserHelpers)
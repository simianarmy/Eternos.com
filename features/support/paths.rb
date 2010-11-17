module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the new co_registration page/
      new_co_registration_path

    when /the home\s?page/
      root_path
      
    when /the login page/
      login_path
    
    when /the choose password page/
      choose_password_user_sessions_path(:protocol => 'https')
      
    when /the account setup page/
      account_setup_path
      
    when /the new story page/
      new_story_path

    when /the new guest page/
      new_guest_path

    when /the choose account page/
      new_account_path

    when /the free account information page/
      new_account_url(:protocol => 'https') + '/Free'

    when /the member homepage/
      member_home_path

    when /the upload file page/
      new_content_path

    when /the media list page/
      contents_path
        
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)

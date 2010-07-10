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
      root_path
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
      
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end
  
end

World(NavigationHelpers)

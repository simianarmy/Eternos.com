Given /^I have artifacts titled (.+)$/ do |titles|
  titles.split(',').each do |title|
    create_content(:title => title, :type => :text, :owner => @current_user)
  end
end

When /^I upload a media file named "(.+)"$/ do |file|
  attach_file 'file-upload',File.join(Test::Unit::TestCase.fixture_path, file)
  click_button
  response.should contain('Success')
end
  
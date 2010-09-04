# STUBS
Given /^the following co_registrations:$/ do |co_registrations|
  CoRegistration.create!(co_registrations.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) co_registration$/ do |pos|
  visit co_registrations_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following co_registrations:$/ do |expected_co_registrations_table|
  expected_co_registrations_table.diff!(tableish('table tr', 'td,th'))
end

# REAL CODE

Given /^I submit my info from the coreg page$/ do
  post '/accounts/aff_create', {:plan => 'Free', :user => {:email => Faker::Internet.email}}
end

Then /I should receive an email containing my login credentials/ do
  open_last_email
  if current_email.body =~ /login: (\S+)/i
    @login = $1
  end
  if current_email.body =~ /password: (\S+)/i
    @password = $1
  end
  @login.should_not be_blank
  @password.should_not be_blank
end
  
When /^I login with my email credentials$/ do
  login_with_credentials @login, @password
end
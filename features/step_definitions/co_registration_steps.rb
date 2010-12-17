World(EternosMailer::Subjects)

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
  post '/accounts/aff_create', {:plan => 'Free', :user => {:email => @email_addr = Faker::Internet.email}}
end

Then /I should receive an email containing my login instructions/ do
  open_email(@email_addr)
  current_email.should have_subject(Regexp.new(subject_from_sym(:signup_notification)))
  if current_email.body =~ /login: (\S+)/i
    @login = $1
  end
  @login.should_not be_blank  
  @login.should == @email_addr
end
  
When /^I enter my password and email and submit the form$/ do 
  passwd = 'fl00bz0m'
  fill_in('user_session[login]', :with => @login)
  fill_in('user_session[password]', :with => passwd)
  fill_in('password_confirmation', :with => passwd)
  click_button "Save"
end
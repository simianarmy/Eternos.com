# $Id$

When /^I choose the "(.*)" account option$/ do |plan|
  choose plan
end

When /^I press continue$/ do
  click_button "Continue"
end

Then /^I fill in my user info as "(.*)"$/ do |email|
  fill_in "first-name", :with => "dr"
  fill_in "last-name", :with => "no"
  fill_in "email", :with => @email = email
  fill_in "user_password", :with => "foofeefoo"
  fill_in "password-confirm", :with => "foofeefoo"
  check "terms_of_service"
end

When /^I fill in my billing info$/ do
  pending
end

Then /^I should receive an activation email$/ do
  Then 'I should receive an email'
  When 'I open the email'
  Then 'I should see "Please activate your new account" in the subject'
end

When /^I click the activation email link$/ do
  When 'I click the first link in the email'
end

Then /^I should receive a welcome email$/ do
  unread_emails_for(@email).size.should == 1 
  open_last_email_for @email
  Then 'I should see "Your account has been activated" in the subject'
end

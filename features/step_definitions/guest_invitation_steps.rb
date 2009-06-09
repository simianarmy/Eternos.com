# $Id$

Given /^I have invited "([^\"]*)" by (.*)$/ do |name, contact_method|
  Then 'I want to add a Child'
  Then "I fill in the info for \"#{name}\""
  Then "I invite guest by #{contact_method}"
  Then 'I press "Save"'
  Then "I should see \"#{name}\""
end

When /^I want to add a (.*)$/ do |circle|
  @relationship = circle
  create_circle(:name => circle, :user_id => user.id)
  When 'I follow "People"'
  Then 'I should see "add a guest"'
end

When /^I press the edit button for "([^\"]*)"/ do |name|
  @guest = GuestInvitation.find_by_name(name)
  click_link controller.dom_id(@guest) + "_edit"
end

When /^I fill in the info for "([^\"]*)"/ do |name|
  fill_in :guest_invitation_name, :with => name
  select @relationship, :from => "guest_invitation_circle_id"
end

When /^I select contact by (.*)$/ do |contact_method|
  choose "toggle_#{contact_method}_contact_method_new_guest_invitation"
end

When /^I change contact method for "([^\"]*)" to (.*)$/ do |name, contact_method|
  @guest = GuestInvitation.find_by_name(name)
  choose "toggle_#{contact_method}_contact_method_#{controller.dom_id(@guest)}"
end

When /^I enter email "([^\"]*)"$/ do |email|
  fill_in :guest_invitation_email, :with => email
end

When /^I enter a mailing address$/ do
  fill_address_fields('new_guest_invitation')
end

When /^I enter a (.*) phone number$/ do |type|
  fill_phone_fields(type, 'guest_invitation')
end

When /^I invite guest by (.*)$/ do |contact_method|
  Then "I select contact by #{contact_method}"
  case contact_method
  when 'email'
    Then 'I enter email "ass@grass.com"'
  when 'phone'
    Then 'I enter a home phone number'
  when 'mail'
    Then 'I enter a mailing address'
  end
end

When /^I want the invitation sent (.*)$/ do |period|
  select period.capitalize, :from => :timelock_type_select
  if period =~ /future/
    select 1.year.from_now.year, :from => 'unlock_on-date-sel'
    select '1 - January', :from => 'unlock_on-date-sel-mm'
    select '1', :from => 'unlock_on-date-sel-dd'
  end
end

Then /^"([^\"]*)" should receive an invitation email from me$/ do |email|
  Then "\"#{email}\" should receive 1 email"
  When "\"#{email}\" opens the email with subject \"#{@current_user.name} has invited you to view their Eternos.com life story\""
end

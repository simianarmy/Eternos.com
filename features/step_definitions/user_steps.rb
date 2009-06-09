Given /^the user (.*) exists$/ do |email|
  @me = create_member(:email => name)
  @me.should be_active
end


Given /^I am not a member$/ do
  log_out
end

Given /^I am logged in/ do
  Then "I login"
end

Given /^I am not logged in$/ do
  log_out
end

When /^I login$/ do
  login_as(@me || create_member)
end

Given /^I login as (.*)$/ do |email|
  unless @me && (@me.email == email)
    @me = create_member(:email => email)
  end
  login_as(@me)
end

Given /^(.*) is logged in$/ do |email|
  Given "the user #{email} exists" 
  Given "I login as #{email}" 
end



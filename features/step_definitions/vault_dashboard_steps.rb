Given /^the following vault_dashboards:$/ do |vault_dashboards|
  VaultDashboard.create!(vault_dashboards.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) vault_dashboard$/ do |pos|
  visit vault_dashboards_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following vault_dashboards:$/ do |expected_vault_dashboards_table|
  expected_vault_dashboards_table.diff!(tableish('table tr', 'td,th'))
end

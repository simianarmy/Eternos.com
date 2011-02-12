Feature: Manage vault_dashboards
  In order to grasp his account state
  As a member
  I want a summary of their account on a single page
  
  @javascript
  Scenario: Logged out member accessing the dashboard
    Given the user "ass@grass.com" exists
    And I am on the vault dashboard page
    Then I should see "Login"
    
  Scenario: Member logging in from the login page
    Given I am logged in
    And I visit the vault dashboard page
    Then I should see "Your Vault Report"


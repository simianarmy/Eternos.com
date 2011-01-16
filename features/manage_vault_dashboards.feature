Feature: Manage vault_dashboards
  In order to study his account information
  A member
  wants to view everything from a dashboard
  
  @javascript
  Scenario: Logged out member accessing the dashboard
    Given the user "ass@grass.com" exists
    And I am on the vault member dashboard page
    Then I should see "Login"
    
  Scenario: Member logging in from the login page
    Given I 
    Then I should see "Your Vault Report"


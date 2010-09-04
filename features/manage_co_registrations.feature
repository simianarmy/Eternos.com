Feature: Manage co_registrations
  In order to access their free coregistered account
  a new user
  wants to be able to login to their eternos account
  
  Scenario: Signup from coreg page
    Given I submit my info from the coreg page
    Then  I should receive an email containing my login credentials
    When I go to the member homepage
    Then I should be on the login page
    When I login with my email credentials
    Then I should be on the account setup page
      

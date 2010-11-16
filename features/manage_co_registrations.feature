Feature: Manage co_registrations
  In order to access their free coregistered account
  a new user
  wants to be able to login to their eternos account
  
  Scenario: Signup from coreg page
    Given I submit my info from the coreg page
    Then  I should receive an email containing my login instructions
    Then I should see "Click here" in the email
    When I follow "Click here" in the email
    Then I should be on the choose password page
    When I enter my password and email and submit the form
    Then I should be on the account setup page
    And I should see "Welcome"
      

Feature: User Authentication
  In order to associate myself with my account
  As a member
  I want to login to my account
  
  Scenario: Login to my account
    Given the user "ass@grass.com" exists
    When I go to the homepage
    And I login as "ass@grass.com"
    Then I should be on the member homepage
    
  Scenario: Logout of my account
   Given "ass@grass.com" is logged in
   When I follow "log out"
   Then I should see "member login"
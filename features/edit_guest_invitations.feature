Feature: Edit guests' invitations
  In order to keep my guests' information up to date
  As a member
  I want to edit their contact information 
  
  Scenario: Change a guest's invitation contact method
    Given I am logged in
    And I have invited "John Smith" by email
    When I press the edit button for "John Smith"
    And I change contact method for "John Smith" to phone
    And I enter a home phone number
    And I press "Save"
    Then I should see "updated!"

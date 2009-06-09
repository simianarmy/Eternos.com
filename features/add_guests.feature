Feature: Add guests
  In order to give loved ones access to my stories
  As a member
  I want to invite them to view my stories by adding them to my guest list
  
  Scenario: Add a guest with email address to invite immediately
    Given I am logged in
    And I want to add a Friend
    When I fill in the info for "John Smith"
    And I invite guest by email
    And I want the invitation sent immediately
    And I press "Save"
    Then I should see "saved!"
    And I should see "invitation by email will be sent soon"
    And I should see "Delivering invitation"
    And I should see "John Smith"
  
  Scenario: Add a guest with phone number to invite immediately
    Given I am logged in
    And I want to add a Friend
    When I fill in the info for "John Smith"
    And I invite guest by phone
    And I want the invitation sent immediately
    And I press "Save"
    Then I should see "saved!"
    And I should see "invitation by phone will be sent soon"
    And I should see "Delivering invitation"
    And I should see "John Smith"
    
  Scenario: Add a guest with mailing address to invite at a future date
    Given I am logged in
    And I want to add a Friend
    When I fill in the info for "John Smith"
    And I invite guest by mail
    And I want the invitation sent at a future date
    And I press "Save"
    Then I should see "saved!"
    And I should see "John Smith"
    And I should see "Pending delivery date"
    But I should not see "invitation by mail will be sent soon"

    



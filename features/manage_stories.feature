Feature: Manage stories
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new story
    Given I am on the new story page
    And I press "Create"

  Scenario: Delete story
    Given the following stories:
      ||
      ||
      ||
      ||
      ||
    When I delete the 3rd story
    Then I should see the following stories:
      ||
      ||
      ||
      ||

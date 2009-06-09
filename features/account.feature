Feature: Membership
  In order to become a member
  As a public user
  I want to signup
  
  Scenario: Create Free Account
    Given I am on the choose account page
    # Requires JS
    When I choose the "basic" account option
    And I press "Continue"
    Then I should see "account information"
    When I fill in my user info as "foo@bar.com"
    And I press "Continue"
    Then I should see "Activate Account"
    And I should receive an activation email
    When I click the activation email link
    Then I should see "Account Created"
    And I should receive a welcome email
  
  Scenario: Create Basic Paid Account
    Given I am on the choose account page
    # Requires JS
    When I choose the "silver" account option
    And I press "Continue"
    Then I should see "account information"
    And I fill in my user info as "foo@bar.com"
    And I press "Continue"
    Then I should see "Payment Information"
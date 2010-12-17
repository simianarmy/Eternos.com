Feature: Membership
  In order to become a member
  As a public user
  I want to signup
  
  Before do
    create_subscription_plans
  end
  
  @free
  Scenario: Create Free Account
    Given I am not a member
    And I go to the homepage
    When I follow "signup"
    Then I should see "select account"
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
  
  @paid
  Scenario: Create Basic Paid Account
    Given I am on the choose account page
    # Requires JS
    When I choose the "silver" account option
    And I press "Continue"
    Then I should see "account information"
    And I fill in my user info as "foo@bar.com"
    And I press "Continue"
    Then I should see "Payment Information"
    When I fill in my billing info
    And I press "Continue"
    Then I should see "Billed!"
    And I should receive a welcome email
    
  @coreg
  @culerity
  Scenario: Create Account from coreg page
    Given I submit my info from the coreg page
    Then  I should receive an email containing my login instructions
    Then I should see "Click here" in the email
    When I follow "Click here" in the email
    Then I should be on the choose password page
    When I enter my password and email and submit the form
    Then I should be on the account setup page
    And I should see "Welcome"
      
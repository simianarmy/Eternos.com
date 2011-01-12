Feature: Membership
  In order to become a vault member
  As a public user
  I want to signup
  
  # Before do
  #     create_subscription_plans
  #   end
  
  @vault_signup_free
  Scenario: Create Free Account
    Given I am not a member
    And I go to the vault homepage
    When I press "Sign Up Now"
    And I fill in the following:
      | Email | ass@grass.com       |
      | Password    | password1     |
      | Password confirmations  |  password1   |
      | Full name   | jack white  |
      | Company name  | conHugeCo |
      | Phone number  | 222-222-2222  |
    And I check "terms_of_service"
    And I press "Choose Account Type"
    # Requires JS
    When I follow "Get Free Account"
    Then I should see "account setup"
    #And I should receive an activation email
    #When I click the activation email link
    #Then I should see "Account Created"
    #And I should receive a welcome email
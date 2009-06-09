Feature: Manage Media
  In order to store media artifacts
  As a member
  I want to upload and manage media files
  
  Scenario: Upload Media
    Given I am logged in
    And I go to the upload file page
    When I upload a media file named "foo.txt"
    And I go to the media list page
    Then I should see "foo"
    
  Scenario: Media List
    Given I am logged in
    And I have artifacts titled Drinky Crow, Wedding Ceremony
    When I go to the media list page
    Then I should see "Drinky Crow"
    And I should see "Wedding Ceremony"
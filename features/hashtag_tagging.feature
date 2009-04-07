Feature: Hashtag tagging
  As a user
  I want to use hashtags
  So I can categorize status updates

  Scenario: Hashtags link to the Hashtag page
    Given I am logged in
    And I am a member of a project
    And there is "1" status with a Hashtag of "#business"
    And I am on the Status page for the project

    When I follow "#business"

    Then I am on the "#business" Hashtag page for the project

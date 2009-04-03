Feature: Gravatar images
  As a user
  I want to see mine and other user's Gravatar images
  So I can recognize who did the update

  Scenario: See Gravatars on the Status page
    Given I am logged in
    And I am on the Status page
    And there are "5" statuses

    Then I should see "5" updates
    And I should see "5" Gravatar images

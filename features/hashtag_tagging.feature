Feature: Hashtag tagging
  As a user
  I want to use hashtags
  So I can categorize status updates

  Scenario: Hashtags link to the Hashtag page
    Given I am logged in
    And I am a member of a project
    And there are "3" statuses with a Hashtag of "#business"
    And I am on the Status page for the project

    When I follow "#business"

    Then I am on the "#business" Hashtag page for the project

  Scenario: Hashtag page showing message for a Hashtag
    Given I am logged in
    And I am a member of a project
    And there are "15" statuses with a Hashtag of "#business"
    And I am on the Hashtag page for "#business" on the project

    Then I should see "15" updates


  Scenario: Tag cloud showing the different tags based on their sizes
    Given I am logged in
    And I am a member of a project
    And there are "10" statuses with a Hashtag of "#business"
    And there are "9" statuses with a Hashtag of "#developer"
    And there are "8" statuses with a Hashtag of "#ruby"
    And there are "7" statuses with a Hashtag of "#rails"
    And there are "6" statuses with a Hashtag of "#redmine"
    And there are "5" statuses with a Hashtag of "#plugin"
    And there are "4" statuses with a Hashtag of "#google"
    And there are "3" statuses with a Hashtag of "#apple"
    And there are "2" statuses with a Hashtag of "#ibm"
    And there are "1" statuses with a Hashtag of "#linux"
    And I am on the Hashtag cloud page for the project

    Then I should see "Tag Cloud"
    And I should see "10" items in the cloud

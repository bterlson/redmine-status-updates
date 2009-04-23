Feature: Search
  As a user
  I want to be able to search for status updates
  So I can eaily find old updates

  Scenario: Search by project
    Given I am logged in
    And I am a member of a project
    And there are "6" statuses with the text "results"
    And I am on the Status page for the project

    When I follow "Search statuses"
    Then I am on the Search page
    When I fill in "status-search" with "results"
    And I press "Submit"

    Then I am on the Search page
    And I should see "Results"
    And I should see "6" updates

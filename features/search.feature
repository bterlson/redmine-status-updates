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
    And I submit the search

    Then I should see "Results"
    And I should see "6" updates

  Scenario: Search all projects
    Given I am logged in
    And I am a member of a project
    And there are "6" statuses with the text "results"
    And I am a member of another project
    And there are "5" statuses for another project with the text "results"
    And I am on the Status page

    When I follow "Search statuses"
    Then I am on the Search page
    When I fill in "status-search" with "results"
    And I submit the search

    Then I should see "Results"
    And I should see "11" updates

  Scenario: Highlight search term
    Given I am logged in
    And I am a member of a project
    And there are "6" statuses with the text "results"
    And I am on the Search page

    When I fill in "status-search" with "results"
    And I submit the search

    Then I should see "6" results highlighted


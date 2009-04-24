Feature: Recent Statuses
  As a user
  I want to see recent statuses on different pages
  So I don't always have to go to the status plugin to see updates

  Scenario: Recent statuses on the Project Overview
    Given I am logged in
    And I am a member of a project
    And there are "6" statuses
    And I am on the Project Overview page

    Then I should see "Status Updates"
    And I should see "5" updates in the left content

  Scenario: Recent statuses on the Homepage
    Given I am logged in
    And I am a member of a project
    And there are "2" statuses
    And I am a member of another project
    And there are "4" statuses for another project
    And I am on the Homepage

    Then I should see "Status Updates"
    And I should see "5" updates in the left content

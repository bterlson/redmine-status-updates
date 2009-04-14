Feature: Cross project listing
  As a user
  I want to see status updates across all visable project
  So I can follow their progress

  Scenario: Top Menu item
    Given I am logged in
    And I am a member of a project
    And I am on the Homepage

    Then I should see a "top" menu item called "Status updates"

  Scenario: View cross project status updates
    Given I am logged in
    And I am a member of a project
    And there are "5" statuses
    And there are "5" statuses for another project
    And I am on the Homepage

    When I follow "Status updates"

    Then I am on the "Status" page
    And I should see "10" updates

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
    And I should see the project name by each update

  Scenario: Display new message form
    Given I am logged in
    And I am a member of a project
    And there are "5" statuses
    And there are "5" statuses for another project
    And I am on the Status page

    Then I should see a "New Message" form
    And I should be able to select which project to post to

  Scenario: Post a new message from the cross project list

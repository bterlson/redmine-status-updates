Feature: Email notification
  As a user
  I want to recieve email notifications of Status Updates
  So I can stay in touch with the progress of the project

  Scenario: Realtime update
    Given I am logged in
    And I am a member of a project
    And I have choosen the 'realtime' notification option
    
    When another user posts an update

    Then I should receive an email
    When I open the email
    Then I should see "Status Update" in the subject
    
  Scenario: Hourly delayed update
    Given I am a member of a project
    And I have choosen the 'hourly' notification option
    And I was last notified over a 'hour' ago
    And there are "15" statuses
    And there are "5" old statuses

    When the status notification task is run

    Then I should receive an email
    When I open the email
    Then I should see "Status Update" in the subject
    And I should see "15" statuses in the email

  Scenario: Eight hour delayed update
    Given I am a member of a project
    And I have choosen the 'eight_hours' notification option
    And I was last notified over '8 hours' ago
    And there are "15" statuses
    And there are "5" old statuses

    When the status notification task is run

    Then I should receive an email
    When I open the email
    Then I should see "Status Update" in the subject
    And I should see "15" statuses in the email

  Scenario: Daily delayed update
    Given I am a member of a project
    And I have choosen the 'daily' notification option
    And I was last notified over a 'day' ago
    And there are "15" statuses
    And there are "5" old statuses

    When the status notification task is run

    Then I should receive an email
    When I open the email
    Then I should see "Status Update" in the subject
    And I should see "15" statuses in the email

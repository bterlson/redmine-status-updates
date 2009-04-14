Feature: Email notifications
  As a user
  I want to recieve email notifications of Status Updates
  So I can know when users post a new update

  Scenario: View my notification preference
    Given I am logged in
    And I am a member of a project
    And I am on the Status page for the project
    
    When I follow "Notification Preferences"

    Then I am on the "Notification Preferences" page
    And I should see "Notification Preference"
    And I should see a form for changing my perference

  Scenario: Update my notification preference
    Given I am logged in
    And I am a member of a project
    And I am on the Status page for the project
    
    When I follow "Notification Preferences"
    And I select "Hourly" from "status_notification_option"
    And I press "Save"

    Then I am on the "Notification Preferences" page
    And I should see "Hourly"
    And my preference should be "hourly"

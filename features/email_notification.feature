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
    
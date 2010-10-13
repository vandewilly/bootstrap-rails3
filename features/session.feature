Feature: Session handling
  In order to use the site
  As a registered user
  I need to be able to signin and signout

  Background:
    Given the confirmed user "1234" exists

  Scenario: Logging in
    Given I am on the signin page
    And I follow "Facebook"
    Then I should "Signed in successfully"

  Scenario: Logging out
    Given I am signed in
    When I go to the signout
    Then I should see "Signed out successfully"



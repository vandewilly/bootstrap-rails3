Feature: Authentication
  In order to have custom content
  As a user
  I want create an account on the website.

  Scenario Outline: Signup
    Given I am not authenticated
    When I go to register
    And I fill in "user_email" with "<email>"
    And I fill in "user_password" with "<password>"
    And I fill in "user_password_confirmation" with "<password>"
    And I press "Sign up"
    Then I should see "You have signed up successfully."

    Examples:
      | email           | password   |
      | testing@man.net | secretpass |
      | foo@bar.com     | fr33z3     |

  Scenario: Login
    Given I am a new, authenticated user
    Then I should see "Signed in successfully."

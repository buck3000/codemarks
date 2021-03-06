@omniauth_test_success @javascript
Feature: Private Codemarks
  In order to hide codemarks from other users
  As a user
  I want to save private codemarks

  Background:
    Given a private tag exists
    Given I am logged in

  @vcr
  Scenario: Saving a private codemark
    When I fill out the add codemark form with "http://www.google.com"
    And I select "private" from ".topics"
    And I submit the codemark form
    Then I should see "Google"
    And that codemark should be private

  Scenario: Viewing my own private codemarks
    And I have a private codemark
    When I am on the codemarks page
    Then I should see that codemark

  Scenario: Cannot view other people's private codemarks
    And another user has a private codemark
    When I am on the codemarks page
    Then I should not see that codemark

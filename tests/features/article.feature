Feature: A User should create an article
  In order for new articles to be published
  As an Administrator
  I want to be able to create Article content.

  Background:
    Given I am logged in as a user with the "administrator" role
      And I visit "node/add/sf_article"
      And I fill in the following:
        | Title | Testing title |

  @api
  Scenario: Make sure that the article type provided by SiteFarm at installation is present.
    Then I should see "Article"

  @api @javascript
  Scenario: Ensure that the WYSIWYG editor is present.
    Then CKEditor "edit-body-0-value" should exist

  @api
  Scenario: Ensure that the article Promote to Front page option is hidden.
    Then I should not see a "input[name='promote[value]']" element

  @api
  Scenario: Ensure that the article Create New Revision is checked.
    When I press "Save and publish"
      And I click "Edit"
    Then the "revision" checkbox should be checked

  @api
  Scenario: Ensure that meta tag fields are present on Articles.
    Then I should see a "input[name='field_sf_meta_tags[0][basic][title]']" element
    And I should see a "textarea[name='field_sf_meta_tags[0][basic][description]']" element

  @api
  Scenario: A url alias should be auto generated for Articles.
    When I press "Save and publish"
    Then I should see "Testing title" in the "Page Title" region
      And I should be on "news/testing-title"

  @api @javascript @local_files
  Scenario: A Primary image should be available to upload.
    When I attach the file "test_16x9.png" to "files[field_sf_primary_image_0]"
      And I wait for AJAX to finish
    Then I should see "Caption" in the ".form-item-field-sf-primary-image-0-title" element
      And I should see "What's the plus sign for?"
    When I fill in "field_sf_primary_image[0][alt]" with "alt text"
      And I fill in "field_sf_primary_image[0][title]" with "title text"
      And I press "Save and publish"
    Then I should see an image in the "Content" region
      And I should see the image alt "alt text" in the "Content" region
      And I should see "title text" in the "Content" region

  @api
  Scenario: Tags added to an Article
    When I fill in "field_sf_tags[target_id]" with "Tag Test, Tag Test 2"
      And I press "Save and publish"
    Then I should see the link "Tag Test" in the "Content" region
      And I should see the link "Tag Test 2" in the "Content" region

  @api
  Scenario: Classify Articles with a single Category taxonomy
    Given "sf_article_category" terms:
      | name          |
      | Test Category |
      | Second Term   |
    When I visit "node/add/sf_article"
      And I fill in the following:
        | Title | Testing title |
      And I select "Test Category" from "field_sf_article_category"
      And I press "Save and publish"
    Then I should see the link "Test Category"

  @api
  Scenario: Classify Articles Type with a single Article Type taxonomy
    When I visit "node/add/sf_article"
      And I fill in the following:
        | Title | Testing title |
      And the "field_sf_article_type" select should be set to "News"
      And I select "Blog" from "field_sf_article_type"
      And I press "Save and publish"
    When I click "Edit"
    Then the "field_sf_article_type" select should be set to "Blog"

  @api
  Scenario: Articles should have a default layout
    When I fill in the following:
      | Body  | Body text |
      And I press "Save and publish"
    Then I should see a ".l-davis-flipped" element
      And I should see "Testing title" in the "Page Title Region"
      And I should see the ".breadcrumbs" element in the "Pre Content Region"

  @api @javascript
  Scenario: Social share buttons on an Article
    Given "sf_article" content:
      | title      |
      | Social Article |
    When I visit "news/social-article"
    Then I should see a ".at-icon-facebook" element
      And I should see a ".at-icon-twitter" element
      And I should see a ".at-icon-google_plusone_share" element
      And I should see a ".at-icon-email" element
      And I should see a ".at-icon-addthis" element

  @api @javascript
  Scenario: Article teasers should strip html from the body summary
    Given the Administration Toolbar is hidden
    When I execute the "feature_block" command in CKEditor
      And I wait for AJAX to finish
      And I select the radio button "Right"
      And I press "OK"
      And I press "Save and publish"
    Then I should see "Title" in the "aside.wysiwyg-feature-block .wysiwyg-feature-block__title" element in the "Content" region
    When I visit "news/"
    Then I should not see the ".wysiwyg-feature-block__body" element in the "Content" region
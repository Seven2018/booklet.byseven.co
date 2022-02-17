require "application_system_test_case"

class MyInterviewsTest < ApplicationSystemTestCase
  setup do
    @my_interview = my_interviews(:one)
  end

  test "visiting the index" do
    visit my_interviews_url
    assert_selector "h1", text: "My Interviews"
  end

  test "creating a My interview" do
    visit my_interviews_url
    click_on "New My Interview"

    click_on "Create My interview"

    assert_text "My interview was successfully created"
    click_on "Back"
  end

  test "updating a My interview" do
    visit my_interviews_url
    click_on "Edit", match: :first

    click_on "Update My interview"

    assert_text "My interview was successfully updated"
    click_on "Back"
  end

  test "destroying a My interview" do
    visit my_interviews_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "My interview was successfully destroyed"
  end
end

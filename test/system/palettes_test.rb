require "application_system_test_case"

class PalettesTest < ApplicationSystemTestCase
  setup do
    @palette = palettes(:one)
  end

  test "visiting the index" do
    visit palettes_url
    assert_selector "h1", text: "Palettes"
  end

  test "should create palette" do
    visit palettes_url
    click_on "New palette"

    click_on "Create Palette"

    assert_text "Palette was successfully created"
    click_on "Back"
  end

  test "should update Palette" do
    visit palette_url(@palette)
    click_on "Edit this palette", match: :first

    click_on "Update Palette"

    assert_text "Palette was successfully updated"
    click_on "Back"
  end

  test "should destroy Palette" do
    visit palette_url(@palette)
    click_on "Destroy this palette", match: :first

    assert_text "Palette was successfully destroyed"
  end
end

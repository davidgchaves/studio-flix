require "rails_helper"

describe "Viewing the list of movies" do
  it "shows the movies" do
    visit movies_url

    expect(page).to have_text "3 Movies"
    expect(page).to have_text "Winter Sleep"
    expect(page).to have_text "Leviathan"
    expect(page).to have_text "The Salt of the Earth"
  end
end

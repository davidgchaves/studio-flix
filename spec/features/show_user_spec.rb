require 'rails_helper'
require 'support/attributes'

feature "Viewing a user's profile page" do
  scenario "shows the user's details" do
    moe = User.create! user_attributes name: "Moe", email: "moe@example.com"

    visit user_url(moe)

    expect(page).to have_css "#user h1", text: moe.name
    expect(page).to have_css "#user a", text: moe.email
  end
end

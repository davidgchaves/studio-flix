require 'rails_helper'
require 'support/attributes'

feature "Viewing the list of users" do
  scenario "shows the users" do
    larry = User.create! user_attributes name: "Larry", email: "larry@example.com"
    moe = User.create! user_attributes name: "Moe", email: "moe@example.com"
    curly = User.create! user_attributes name: "Curly", email: "curly@example.com"

    visit users_url

    expect(page).to have_link larry.name
    expect(page).to have_link moe.name
    expect(page).to have_link curly.name
  end
end

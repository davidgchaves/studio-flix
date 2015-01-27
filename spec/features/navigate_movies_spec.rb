require "rails_helper"
require "support/attributes"

describe "Navigating movies" do
  let!(:movie) { movie = Movie.create movie_attributes }

  it "allows navigation from the listing page to the create page" do
    visit movies_url

    click_link "Add New Movie"

    expect(current_path).to eq new_movie_path
  end

  it "allows navigation from the create page to the detail page" do
    visit movies_url
    click_link "Add New Movie"
    fill_in "Title", with: "New Movie Title"
    fill_in "Description", with: "Superheroes saving the world from villains"
    fill_in "Rating", with: "PG-13"
    fill_in "Total gross", with: "75000000"
    select (Time.now.year - 1).to_s, :from => "movie_released_on_1i"

    click_button "Create Movie"

    expect(current_path).to eq movie_path(Movie.last)
  end

  it "allows navigation from the details page to the listing page destroying a movie" do
    visit movie_url(movie)

    click_link "Delete"

    expect(current_path).to eq movies_path
  end
end

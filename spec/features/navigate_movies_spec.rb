require "rails_helper"
require "support/attributes"

describe "Navigating movies" do
  let!(:movie) { movie = Movie.create movie_attributes }

  it "allows navigation from the detail page to the listing page" do
    visit movie_url(movie)

    click_link "All Movies"

    expect(current_path).to eq movies_path
  end

  it "allows navigation from the listing page to the detail page" do
    visit movies_url

    click_link movie.title

    expect(current_path).to eq movie_path(movie)
  end
end

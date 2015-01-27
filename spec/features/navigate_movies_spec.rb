require "rails_helper"
require "support/attributes"

describe "Navigating movies" do
  let!(:movie) { movie = Movie.create movie_attributes }

  it "allows navigation from the details page to the listing page destroying a movie" do
    visit movie_url(movie)

    click_link "Delete"

    expect(current_path).to eq movies_path
  end
end

require "rails_helper"
require "support/attributes"

describe "Deleting a movie" do
  it "shows the movie listing without the deleted movie" do
    movie = Movie.create movie_attributes
    visit movie_url(movie)

    click_link "Delete"

    expect(page).not_to have_text movie.title
    expect(page).not_to have_text movie.description
  end
end

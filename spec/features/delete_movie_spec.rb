require "rails_helper"
require "support/attributes"

describe "Deleting a movie" do
  let!(:movie) { Movie.create movie_attributes }

  before(:example) do
    visit movie_url(movie)
    click_link "Delete"
  end

  it "redirects to the listing page destroying a movie" do
    expect(current_path).to eq movies_path
  end

  it "shows the movie listing without the deleted movie" do
    expect(page).not_to have_text movie.title
    expect(page).not_to have_text movie.description
  end

  it "flashes a 'movie successfully deleted' message" do
    expect(page).to have_text "Movie successfully deleted!"
  end
end

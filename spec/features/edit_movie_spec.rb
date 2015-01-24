require "rails_helper"
require "support/attributes"

describe "Editing a movie" do
  it "shows the form to edit movies" do
    movie = Movie.create movie_attributes
    visit movie_path(movie)

    click_link "Edit"

    expect(find_field('Title').value).to eq movie.title
  end

  it "shows the movie's updated details" do
    movie = Movie.create movie_attributes
    visit movie_path(movie)
    click_link "Edit"
    fill_in "Title" , with: "Updated Movie Title"

    click_button "Update Movie"

    expect(page).to have_text "Updated Movie Title"
  end
end

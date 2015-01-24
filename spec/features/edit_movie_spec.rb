require "rails_helper"
require "support/attributes"

describe "Editing a movie" do
  it "shows the form to edit movies" do
    movie = Movie.create movie_attributes
    visit movie_path(movie)

    click_link "Edit"

    expect(find_field('Title').value).to eq movie.title
  end
end

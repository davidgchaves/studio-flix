require "rails_helper"
require "support/attributes"

describe "The sidebar" do
  before do
    movie = Movie.create movie_attributes
    visit movie_url(movie)
  end

  it "allows direct navigation to the listing page" do
    click_link "All Movies"

    expect(current_path).to eq movies_path
  end

  it "allows direct navigation to the add new movie page" do
    click_link "Add New Movie"

    expect(current_path).to eq new_movie_path
  end
end

require "rails_helper"
require "support/attributes"

describe "The sidebar" do
  it "allows direct navigation to the listing page" do
    movie = Movie.create movie_attributes
    visit movie_url(movie)

    click_link "All Movies"

    expect(current_path).to eq movies_path
  end
end

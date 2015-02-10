require 'rails_helper'
require 'support/attributes'

describe "Creating a new review for a movie" do
  it "goes to the create review page" do
    movie = Movie.create movie_attributes
    visit movie_url(movie)

    click_link "Write Review"

    expect(current_path).to eq new_movie_review_path(movie)
  end
end

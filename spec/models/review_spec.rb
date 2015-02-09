require 'rails_helper'
require 'support/attributes'

describe "A review" do
  it "belongs to a movie" do
    movie = Movie.create movie_attributes

    review = movie.reviews.new review_attributes

    expect(review.movie).to eq movie
  end
end


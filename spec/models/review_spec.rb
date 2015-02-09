require 'rails_helper'
require 'support/attributes'

describe "A review" do
  it "belongs to a movie" do
    movie = Movie.create movie_attributes

    review = movie.reviews.new review_attributes

    expect(review.movie).to eq movie
  end

  it "requires a name" do
    invalid_review = Review.new name: ""

    invalid_review.valid?

    expect(invalid_review.errors[:name].any?).to eq true
  end
end


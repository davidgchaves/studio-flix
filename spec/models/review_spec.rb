require 'rails_helper'
require 'support/attributes'

describe Review do
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

  it "requires a comment with at least 4 characters" do
    invalid_review = Review.new comment: "X" * 3

    invalid_review.valid?

    expect(invalid_review.errors[:comment].any?).to eq true
  end

  it "rejects invalid star values with a custom error message" do
    invalid_stars = [0, -1, 6, 10]
    invalid_stars.each do |invalid_star|
      invalid_review = Review.new stars: invalid_star

      invalid_review.valid?

      expect(invalid_review.errors[:stars].first).to eq "must be between 1 and 5"
    end
  end

  it "accepts star values of 1 to 5" do
    valid_stars = [1,2,3,4,5]
    valid_stars.each do |valid_star|
      valid_review = Review.new review_attributes(stars: valid_star)

      valid_review.valid?

      expect(valid_review.errors[:stars].any?).to eq false
    end
  end

  it "rejects bad formatted locations with a custom message" do
    invalid_locations = ["Boston, MAS", "Austin,TX", "Portland-OR", "portland, OR", "Portland, or"]
    invalid_locations.each do |invalid_location|
      invalid_review = Review.new location: invalid_location

      invalid_review.valid?

      expect(invalid_review.errors[:location].first).to eq "must be 'City, STATE' (with that casing)"
    end
  end

  it "accepts well formatted locations" do
    valid_locations = ["Boston, MA", "Austin, TX", "Portland, OR"]
    valid_locations.each do |valid_location|
      valid_review = Review.new review_attributes(location: valid_location)

      valid_review.valid?

      expect(valid_review.errors[:location].any?).to eq false
    end
  end

  it "is valid with example attributes" do
    review = Review.new review_attributes

    expect(review.valid?).to eq true
  end
end


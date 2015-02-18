require 'rails_helper'
require 'support/attributes'

describe Review do
  it "belongs to a movie" do
    expect(subject).to belong_to :movie
  end

  describe "name" do
    it "can't be blank" do
      expect(subject).to validate_presence_of :name
    end
  end

  describe "comment" do
    it "contains at least 4 characters" do
      expect(subject).to validate_length_of(:comment).is_at_least(4)
    end
  end

  describe "stars rating" do
    it "is valid when values are in the range of 1 to 5" do
        expect(subject).to validate_inclusion_of(:stars).
          in_range(1..5).
          with_message("must be between 1 and 5")
    end
  end

  describe "location" do
    context "when properly formatted" do
      let(:valid_locations) { ["Boston, MA", "Austin, TX", "Portland, OR"] }

      it "is valid" do
        valid_locations.each do |valid_location|
          expect(subject).to allow_value(valid_location).for :location
        end
      end
    end

    context "when improperly formatted" do
      let(:invalid_locations) { ["Boston, MAS", "Austin,TX", "Portland-OR", "portland, OR", "Portland, or"] }

      it "is invalid" do
        invalid_locations.each do |invalid_location|
          expect(subject).not_to allow_value(invalid_location).for :location
        end
      end
    end
  end

  it "is valid with example attributes" do
    review = Review.new review_attributes

    expect(review.valid?).to eq true
  end
end


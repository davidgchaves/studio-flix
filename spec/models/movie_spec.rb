require "rails_helper"
require "support/attributes"

describe "A movie" do
  it "is a flop if the total gross is less than $50M" do
    movie = Movie.new total_gross: 40000000.00

    expect(movie.flop?).to eq true
  end

  it "is a flop if the total gross is blank" do
    movie = Movie.new total_gross: nil

    expect(movie.flop?).to eq true
  end

  it "is not a flop if the total gross exceeds $50M" do
    movie = Movie.new total_gross: 60000000.00

    expect(movie.flop?).to eq false
  end

  it "is released when the released on date is the past" do
    movie = Movie.create movie_attributes(released_on: 3.months.ago)

    expect(Movie.released).to include movie
  end

  it "is not released when the released on date is in the future" do
    movie = Movie.create movie_attributes(released_on: 3.months.from_now)

    expect(Movie.released).not_to include movie
  end

  it "returns released movies ordered with the most recently-released movie first" do
    movie1 = Movie.create movie_attributes(released_on: 3.months.ago)
    movie2 = Movie.create movie_attributes(released_on: 2.months.ago)
    movie3 = Movie.create movie_attributes(released_on: 1.month.ago)

    expect(Movie.released).to eq [movie3, movie2, movie1]
  end

  it "is a hit when the total gross is at least $300M" do
    movie = Movie.create movie_attributes(total_gross: 400000000)

    expect(Movie.hits).to include movie
  end

  it "is not a hit when the total gross is less than $300M" do
    movie = Movie.create movie_attributes(total_gross: 200000000)

    expect(Movie.hits).not_to include movie
  end

  it "returns hits movies ordered with the highest grossing movie first" do
    movie1 = Movie.create movie_attributes(total_gross: 300000000)
    movie2 = Movie.create movie_attributes(total_gross: 400000000)
    movie3 = Movie.create movie_attributes(total_gross: 500000000)

    expect(Movie.hits).to eq [movie3, movie2, movie1]
  end
end

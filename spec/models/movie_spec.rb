require "rails_helper"
require "support/attributes"

describe "A movie" do
  it "is a flop if the total gross is less than $50M" do
    flop_movie = Movie.new total_gross: 40000000.00

    expect(flop_movie.flop?).to eq true
  end

  it "is a flop if the total gross is blank" do
    flop_movie = Movie.new total_gross: nil

    expect(flop_movie.flop?).to eq true
  end

  it "is not a flop if the total gross exceeds $50M" do
    movie = Movie.new total_gross: 60000000.00

    expect(movie.flop?).to eq false
  end

  it "is released when the released on date is the past" do
    released_movie = Movie.create movie_attributes(released_on: 3.months.ago)

    expect(Movie.released).to include released_movie
  end

  it "is not released when the released on date is in the future" do
    movie = Movie.create movie_attributes(released_on: 3.months.from_now)

    expect(Movie.released).not_to include movie
  end

  it "returns released movies ordered with the most recently-released movie first" do
    released_movie1 = Movie.create movie_attributes(released_on: 3.months.ago)
    released_movie2 = Movie.create movie_attributes(released_on: 2.months.ago)
    released_movie3 = Movie.create movie_attributes(released_on: 1.month.ago)

    expect(Movie.released).to eq [released_movie3, released_movie2, released_movie1]
  end

  it "is a hit when the total gross is at least $300M" do
    hit_movie = Movie.create movie_attributes(total_gross: 400000000)

    expect(Movie.hits).to include hit_movie
  end

  it "is not a hit when the total gross is less than $300M" do
    movie = Movie.create movie_attributes(total_gross: 200000000)

    expect(Movie.hits).not_to include movie
  end

  it "returns hits movies ordered with the highest grossing movie first" do
    hit_movie1 = Movie.create movie_attributes(total_gross: 300000000)
    hit_movie2 = Movie.create movie_attributes(total_gross: 400000000)
    hit_movie3 = Movie.create movie_attributes(total_gross: 500000000)

    expect(Movie.hits).to eq [hit_movie3, hit_movie2, hit_movie1]
  end

  it "is a flop when the total gross is less than $50M" do
    flop_movie = Movie.create movie_attributes(total_gross: 30000000)

    expect(Movie.flops).to include flop_movie
  end

  it "is not a flop when the total gross is at least $50M" do
    movie = Movie.create movie_attributes(total_gross: 60000000)

    expect(Movie.flops).not_to include movie
  end

  it "returns flops movies ordered with the lowest grossing movie first" do
    flop_movie1 = Movie.create movie_attributes(total_gross: 40000000)
    flop_movie2 = Movie.create movie_attributes(total_gross: 30000000)
    flop_movie3 = Movie.create movie_attributes(total_gross: 20000000)

    expect(Movie.flops).to eq [flop_movie3, flop_movie2, flop_movie1]
  end
end

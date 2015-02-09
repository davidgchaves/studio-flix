require "rails_helper"
require "support/attributes"

describe "A movie" do
  it "has many reviews" do
    movie = Movie.create movie_attributes

    review1 = movie.reviews.new review_attributes
    review2 = movie.reviews.new review_attributes

    expect(movie.reviews).to include review1
    expect(movie.reviews).to include review2
  end

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

  it "is recently added when is one of the last 3 created movies" do
    3.times { Movie.create movie_attributes(created_at: 1.hour.ago) }
    recently_added_movie = Movie.create movie_attributes(created_at: Time.now)

    expect(Movie.recently_added).to include recently_added_movie
  end

  it "is not recently added when is not one of the last 3 created movies" do
    movie = Movie.create movie_attributes(created_at: 1.hour.ago)
    3.times { Movie.create movie_attributes(created_at: Time.now) }

    expect(Movie.recently_added).not_to include movie
  end

  it "returns recently added movies ordered with the most recently added movie first" do
    movie1 = Movie.create movie_attributes(created_at: 3.hours.ago)
    movie2 = Movie.create movie_attributes(created_at: 2.hours.ago)
    movie3 = Movie.create movie_attributes(created_at: 1.hours.ago)

    expect(Movie.recently_added).to eq [movie3, movie2, movie1]
  end

  it "requires a title" do
    movie = Movie.new title: ""

    movie.valid?

    expect(movie.errors[:title].any?).to eq true
  end

  it "requires a description with at least 25 characters" do
    movie = Movie.new description: "X" * 24

    movie.valid?

    expect(movie.errors[:description].any?).to eq true
  end

  it "requires a released on date" do
    movie = Movie.new released_on: ""

    movie.valid?

    expect(movie.errors[:released_on].any?).to eq true
  end

  it "requires a duration" do
    movie = Movie.new duration: ""

    movie.valid?

    expect(movie.errors[:duration].any?).to eq true
  end

  it "rejects a negative total gross" do
    movie = Movie.new total_gross: -123456.00

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq true
  end

  it "accepts a positive (or $0) total gross" do
    totals = %w[0.00 20000000.00]
    totals.each do |total_gross|
      movie = Movie.new total_gross: total_gross

      movie.valid?

      expect(movie.errors[:total_gross].any?).to eq false
    end
  end

  it "rejects improperly formatted image file names" do
    invalid_file_names = %w[movie .jpg .png .gif movie.pdf movie.doc]
    invalid_file_names.each do |invalid_file_name|
      movie = Movie.new image_file_name: invalid_file_name

      movie.valid?

      expect(movie.errors[:image_file_name].any?).to eq true
    end
  end

  it "accepts a blank image file name" do
    movie = Movie.new image_file_name: ""

    movie.valid?

    expect(movie.errors[:image_file_name].any?).to eq false
  end

  it "accepts properly formatted image file names" do
    valid_file_names = %w[e.png movie.png movie.jpg movie.gif MOVIE.GIF]
    valid_file_names.each do |valid_file_name|
      movie = Movie.new image_file_name: valid_file_name

      movie.valid?

      expect(movie.errors[:image_file_name].any?).to eq false
    end
  end

  it "rejects any rating that is not in the approved list" do
    wrong_ratings = %w[R-13 R-16 R-18 R-21]
    wrong_ratings.each do |wrong_rating|
      movie = Movie.new rating: wrong_rating

      movie.valid?

      expect(movie.errors[:rating].any?).to eq true
    end
  end

  it "accepts any rating that is in an approved list" do
    valid_ratings = %w[G PG PG-13 R NC-17]
    valid_ratings.each do |valid_rating|
      movie = Movie.new rating: valid_rating

      movie.valid?

      expect(movie.errors[:rating].any?).to eq false
    end
  end

  it "is valid with example attributes" do
    movie = Movie.new movie_attributes

    expect(movie.valid?).to eq true
  end
end

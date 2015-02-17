require "rails_helper"
require "support/attributes"

describe Movie do

  context "with example attributes" do
    it "is valid" do
      valid_movie = Movie.new movie_attributes

      expect(valid_movie.valid?).to be_truthy
    end
  end

  it "has many (destroy dependent) reviews" do
    expect(subject).to have_many(:reviews).dependent :destroy
  end

  context "title" do
    it "can't be blank" do
      expect(subject).to validate_presence_of :title
    end
  end

  context "duration" do
    it "can't be blank" do
      expect(subject).to validate_presence_of :duration
    end
  end

  context "released on date" do
    it "can't be blank" do
      expect(subject).to validate_presence_of :released_on
    end
  end

  context "description" do
    it "contains at least 25 characters" do
      expect(subject).to validate_length_of(:description).is_at_least 25
    end
  end

  context "total gross" do
    it "is at least 0$" do
      expect(subject).to validate_numericality_of(:total_gross).is_greater_than_or_equal_to 0
    end
  end

  context "rating" do
    it "is picked from an approved ratings list" do
      expect(subject).to validate_inclusion_of(:rating).in_array %w[G PG PG-13 R NC-17]
    end
  end

  context "image filename" do
    it "can be blank" do
      expect(subject).to allow_value("").for :image_file_name
    end
  end

  context "Being a flop" do
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

    it "is never a flop if it's a cult classic, no matter the total gross" do
      cult_movie = Movie.create movie_attributes(total_gross: 0.00)
      allow(cult_movie).to receive(:cult_classic?) { true }

      expect(cult_movie.flop?).to eq false
    end
  end

  context "Being a cult classic" do
    it "is a cult classic when it has more than 50 reviews and its average review is at least 4 stars" do
      movie = Movie.create movie_attributes
      51.times { movie.reviews.create review_attributes(stars: 4) }

      expect(movie).to be_a_cult_classic
    end

    it "is not a cult classic when it has less than 50 reviews" do
      movie = Movie.create movie_attributes
      3.times { movie.reviews.create review_attributes(stars: 5) }

      expect(movie).not_to be_a_cult_classic
    end

    it "is not a cult classic when its average review is lower than 4 stars" do
      movie = Movie.create movie_attributes
      51.times { movie.reviews.create review_attributes(stars: 3) }

      expect(movie).not_to be_a_cult_classic
    end
  end

  context "released query" do
    let(:unreleased_movie) { Movie.create movie_attributes(released_on: 3.months.from_now) }
    let(:released_movie1) { Movie.create movie_attributes(released_on: 3.months.ago) }
    let(:released_movie2) { Movie.create movie_attributes(released_on: 2.months.ago) }
    let(:released_movie3) { Movie.create movie_attributes(released_on: 1.month.ago) }

    it "only returns movies with a released on date in the past" do
      expect(Movie.released).to include released_movie1
    end

    it "never returns movies with a released on date in the future" do
      expect(Movie.released).not_to include unreleased_movie
    end

    it "returns released movies ordered with the most recently-released movie first" do
      expect(Movie.released).to eq [released_movie3, released_movie2, released_movie1]
    end
  end

  context "flops query" do
    let(:movie) { Movie.create movie_attributes(total_gross: 60000000) }
    let(:flop_movie1) { Movie.create movie_attributes(total_gross: 40000000) }
    let(:flop_movie2) { Movie.create movie_attributes(total_gross: 30000000) }
    let(:flop_movie3) { Movie.create movie_attributes(total_gross: 20000000) }

    it "only returns movies with a total gross less than $50M" do
      expect(Movie.flops).to include flop_movie1
    end

    it "never returns movies with a total gross of at least $50M" do
      expect(Movie.flops).not_to include movie
    end

    it "returns flops movies ordered with the lowest grossing movie first" do
      expect(Movie.flops).to eq [flop_movie3, flop_movie2, flop_movie1]
    end
  end

  context "hits query" do
    let(:movie) { Movie.create movie_attributes(total_gross: 200000000) }
    let(:hit_movie1) { Movie.create movie_attributes(total_gross: 300000000) }
    let(:hit_movie2) { Movie.create movie_attributes(total_gross: 400000000) }
    let(:hit_movie3) { Movie.create movie_attributes(total_gross: 500000000) }

    it "only returns movies with a total gross of at least $300M" do
      expect(Movie.hits).to include hit_movie1
    end

    it "never returns movies with a total gross of less than $300M" do
      expect(Movie.hits).not_to include movie
    end

    it "returns hit movies ordered with the highest grossing movie first" do
      expect(Movie.hits).to eq [hit_movie3, hit_movie2, hit_movie1]
    end
  end

  context "recently added query" do
    let(:movie1) { Movie.create movie_attributes(created_at: 3.hours.ago) }
    let(:movie2) { Movie.create movie_attributes(created_at: 2.hours.ago) }
    let(:movie3) { Movie.create movie_attributes(created_at: 1.hours.ago) }

    it "only returns the last 3 created movies" do
      3.times { Movie.create movie_attributes(created_at: 1.hour.ago) }
      recently_added_movie = Movie.create movie_attributes(created_at: Time.now)

      expect(Movie.recently_added).to include recently_added_movie
    end

    it "never returns movies that are not one of the last 3 created movies" do
      3.times { Movie.create movie_attributes(created_at: Time.now) }

      expect(Movie.recently_added).not_to include movie1
    end

    it "returns recently added movies ordered with the most recently added movie first" do
      expect(Movie.recently_added).to eq [movie3, movie2, movie1]
    end
  end

  context "Validations" do

    context "Rejections" do
      it "rejects improperly formatted image file names" do
        invalid_file_names = %w[movie .jpg .png .gif movie.pdf movie.doc]
        invalid_file_names.each do |invalid_file_name|
          movie = Movie.new image_file_name: invalid_file_name

          movie.valid?

          expect(movie.errors[:image_file_name].any?).to eq true
        end
      end
    end

    context "Acceptances" do
      it "accepts properly formatted image file names" do
        valid_file_names = %w[e.png movie.png movie.jpg movie.gif MOVIE.GIF]
        valid_file_names.each do |valid_file_name|
          movie = Movie.new image_file_name: valid_file_name

          movie.valid?

          expect(movie.errors[:image_file_name].any?).to eq false
        end
      end
    end
  end

  it "calculates the average number of review stars" do
    movie = Movie.create movie_attributes
    movie.reviews.create review_attributes(stars: 1)
    movie.reviews.create review_attributes(stars: 3)
    movie.reviews.create review_attributes(stars: 5)

    expect(movie.average_stars).to eq 3
  end

  it "returns its two most-recently posted reviews" do
    movie = Movie.create movie_attributes
    3.times { movie.reviews.create review_attributes(created_at: 1.hour.ago) }
    recent_review1 = movie.reviews.create review_attributes
    recent_review2 = movie.reviews.create review_attributes

    expect(movie.recent_reviews).to eq [recent_review2, recent_review1]
  end
end

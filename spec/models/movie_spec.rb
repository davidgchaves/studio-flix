require "rails_helper"
require "support/attributes"

describe Movie do
  let(:movie) { Movie.create movie_attributes }

  context "with example attributes" do
    it "is valid" do
      expect(movie.valid?).to be_truthy
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

    context "when properly formatted" do
      let(:valid_file_names) { %w[e.png movie.png movie.jpg movie.gif MOVIE.GIF] }

      it "is valid" do
        valid_file_names.each do |valid_file_name|
          expect(subject).to allow_value(valid_file_name).for :image_file_name
        end
      end
    end

    context "when improperly formatted" do
      let(:invalid_file_names) { %w[movie .jpg .png .gif movie.pdf movie.doc] }

      it "is invalid" do
        invalid_file_names.each do |invalid_file_name|
          expect(subject).not_to allow_value(invalid_file_name).for :image_file_name
        end
      end
    end
  end

  context "with more than 50 reviews" do
    before(:example) { expect(movie).to receive(:more_than_50_reviews?).and_return(true).once }

    context "and an average of at least 4 stars" do
      before(:example) { expect(movie).to receive(:average_stars).and_return(4).once }

      it "is a cult classic" do
        expect(movie).to be_a_cult_classic
      end
    end

    context "and an average lower than 4 stars" do
      before(:example) { expect(movie).to receive(:average_stars).and_return(3).once }

      it "can't be a cult classic" do
        expect(movie).not_to be_a_cult_classic
      end
    end
  end

  context "with 50 or less reviews" do
    before(:example) { expect(movie).to receive(:more_than_50_reviews?).and_return(false).once }

    it "can't be a cult classic" do
      expect(movie).not_to be_a_cult_classic
    end
  end

  context "that is a cult classic" do
    let(:cult_classic_movie) { Movie.create movie_attributes(total_gross: 0.00) }
    before(:example) { expect(cult_classic_movie).to receive(:cult_classic?).and_return(true).once }

    it "is never a flop" do
      expect(cult_classic_movie).not_to be_a_flop
    end
  end

  context "that is not a cult classic" do
    before(:example) { expect(movie).to receive(:cult_classic?).and_return(false).once }

    context "and less than $50M total gross" do
      before(:example) { expect(movie).to receive(:total_gross).and_return(40000000.00).at_least :once }

      it "is a flop" do
        expect(movie).to be_a_flop
      end
    end

    context "and a blank total gross" do
      before(:example) { expect(movie).to receive(:total_gross).and_return(nil).at_least :once }

      it "is a flop" do
        expect(movie).to be_a_flop
      end
    end

    context "and a $50M or more total gross" do
      before(:example) { expect(movie).to receive(:total_gross).and_return(50000000.00).at_least :once }

      it "can't be a flop" do
        expect(movie).not_to be_a_flop
      end
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

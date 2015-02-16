require "rails_helper"
require "support/attributes"

describe "Viewing an individual movie" do
  let(:movie) { Movie.create movie_attributes }

  it "shows the movie's details" do
    visit movie_url(movie)

    expect(page).to have_text movie.title
    expect(page).to have_text movie.rating
    expect(page).to have_text movie.description
    expect(page).to have_text movie.released_on
    expect(page).to have_text movie.cast
    expect(page).to have_text movie.director
    expect(page).to have_text movie.duration
  end

  context "when the total gross exceeds $50M" do
    let(:movie) { Movie.create movie_attributes(total_gross: 60000000.00) }
    before(:example) { visit movie_url(movie) }

    it "shows the total gross" do
      expect(page).to have_text "$60,000,000.00"
    end
  end

  context "when the total gross is less than $50M" do
    let(:flop_movie) { Movie.create movie_attributes(total_gross: 40000000.00) }
    before(:example) { visit movie_url(flop_movie) }

    it "shows 'Flop!'" do
      expect(page).to have_text "Flop!"
    end
  end

  context "when there's a poster associated to the movie" do
    let(:movie_with_poster) { Movie.create movie_attributes(image_file_name: "wintersleep.jpg") }
    before(:example) { visit movie_url(movie_with_poster) }

    it "shows the movie's poster" do
      expect(page).to have_selector "img[src$='#{movie_with_poster.image_file_name}']"
    end
  end

  context "when there's no poster associated to the movie" do
    let(:movie_with_no_poster) { Movie.create movie_attributes(image_file_name: "") }
    before(:example) { visit movie_url(movie_with_no_poster) }

    it "shows a default poster" do
      expect(page).to have_selector "img[src$='placeholder.png']"
    end
  end

  context "when there's at least a review" do
    let(:movie) do
      m = Movie.create movie_attributes
      m.reviews.create review_attributes(stars: 1)
      m
    end
    let!(:recent_review1) { movie.reviews.create review_attributes(stars: 4) }
    let!(:recent_review2) { movie.reviews.create review_attributes(stars: 2) }

    before(:example) { visit movie_url(movie) }

    it "shows the average number of review stars" do
      expect(page).to have_text "2.3 stars"
    end

    it "shows the most-recently posted reviews" do
      expect(page).to have_text "#{recent_review1.stars} stars"
      expect(page).to have_text "#{recent_review2.stars} stars"
    end
  end

  context "when there's no reviews" do
    let(:movie) { Movie.create movie_attributes }
    before(:example) { visit movie_url(movie) }

    it "shows a 'No Reviews' message" do
      expect(page).to have_text "No Reviews"
    end

    it "does not show the reviews section" do
      expect(page).not_to have_css "section#reviews"
    end
  end

  context "with reviews" do
    let(:movie_with_2_reviews) do
      m = Movie.create movie_attributes
      m.reviews.create review_attributes
      m.reviews.create review_attributes
      m
    end

    it "allows navigation to the listing reviews page" do
      visit movie_url(movie_with_2_reviews)

      click_link "2 reviews"

      expect(current_path).to eq movie_reviews_path(movie_with_2_reviews)
    end
  end
end

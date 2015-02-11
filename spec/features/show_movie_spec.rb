require "rails_helper"
require "support/attributes"

describe "Viewing an individual movie" do
  let!(:movie) { Movie.create movie_attributes }

  it "shows the movie's details" do
    visit movie_url(movie)

    expect(page).to have_text movie.title
    expect(page).to have_text movie.rating
    expect(page).to have_text movie.description
    expect(page).to have_text movie.released_on
    expect(page).to have_text movie.cast
    expect(page).to have_text movie.director
    expect(page).to have_text movie.duration
    expect(page).to have_selector "img[src$='#{movie.image_file_name}']"
  end

  it "shows the total gross if the total gross exceeds $50M" do
    movie = Movie.create movie_attributes(total_gross: 60000000.00)

    visit movie_url(movie)

    expect(page).to have_text "$60,000,000.00"
  end

  it "shows 'Flop!' if the total gross is less than $50M" do
    flop_movie = Movie.create movie_attributes(total_gross: 40000000.00)

    visit movie_url(flop_movie)

    expect(page).to have_text "Flop!"
  end

  it "shows the movie's poster when there's a poster associated to the movie" do
    movie_with_poster = Movie.create movie_attributes(image_file_name: "wintersleep.jpg")

    visit movie_url(movie_with_poster)

    expect(page).to have_selector "img[src$='#{movie_with_poster.image_file_name}']"
  end

  it "shows a default poster when there's no poster associated to the movie" do
    movie_with_no_poster = Movie.create movie_attributes(image_file_name: "")

    visit movie_url(movie_with_no_poster)

    expect(page).to have_selector "img[src$='placeholder.png']"
  end

  it "shows the average number of review stars when there's at least a review" do
    movie = Movie.create movie_attributes
    movie.reviews.create review_attributes(stars: 1)
    movie.reviews.create review_attributes(stars: 4)
    movie.reviews.create review_attributes(stars: 2)

    visit movie_url(movie)

    expect(page).to have_text "2.3 stars"
  end

  it "shows a 'No Reviews' message when there's no reviews" do
    movie = Movie.create movie_attributes

    visit movie_url(movie)

    expect(page).to have_text "No Reviews"
  end

  it "allows navigation to its reviews" do
    movie = Movie.create movie_attributes
    review1 = movie.reviews.create review_attributes
    review2 = movie.reviews.create review_attributes
    visit movie_url(movie)

    click_link "2 reviews"

    expect(current_path).to eq movie_reviews_path(movie)
  end
end

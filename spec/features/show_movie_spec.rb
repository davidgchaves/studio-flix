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
    movie = Movie.create movie_attributes(total_gross: 40000000.00)

    visit movie_url(movie)

    expect(page).to have_text "Flop!"
  end

  it "shows the movie's poster when there's a poster associated to the movie" do
    movie_with_poster = Movie.create movie_attributes(image_file_name: "wintersleep.jpg")

    visit movie_url(movie_with_poster)

    expect(page).to have_selector "img[src$='#{movie_with_poster.image_file_name}']"
  end

  it "show a default poster when there's no poster associated to the movie" do
    movie_with_no_poster = Movie.create movie_attributes(image_file_name: "")

    visit movie_url(movie_with_no_poster)

    expect(page).to have_selector "img[src$='placeholder.png']"
  end

  it "allows navigation to the listing page" do
    visit movie_url(movie)

    click_link "All Movies"

    expect(current_path).to eq movies_path
  end
end

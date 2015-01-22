require "rails_helper"

describe "Viewing an individual movie" do
  it "shows the movie's details" do
    movie = Movie.create title: "Winter Sleep",
                         rating: "PG",
                         total_gross: 318412101.00,
                         description: "If only Bergman were Turkish",
                         released_on: "2014-06-13"

    visit movie_url(movie)

    expect(page).to have_text movie.title
    expect(page).to have_text movie.rating
    expect(page).to have_text "$318,412,101.00"
    expect(page).to have_text movie.description
    expect(page).to have_text movie.released_on
  end
end

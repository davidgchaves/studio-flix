require "rails_helper"

describe "Navigating movies" do
  it "allows navigation from the detail page to the listing page" do
    movie = Movie.create title: "Winter Sleep",
                         rating: "PG",
                         total_gross: 318412101.00,
                         description: "If only Bergman were Turkish",
                         released_on: "2014-06-13"
    visit movie_url(movie)

    click_link "All Movies"

    expect(current_path).to eq movies_path
  end

  it "allows navigation from the listing page to the detail page" do
    movie = Movie.create title: "Winter Sleep",
                         rating: "PG",
                         total_gross: 318412101.00,
                         description: "If only Bergman were Turkish",
                         released_on: "2014-06-13"
    visit movies_url

    click_link movie.title

    expect(current_path).to eq movie_path(movie)
  end
end

require "rails_helper"

describe "Viewing the list of movies" do
  let!(:movie1) { Movie.create title: "Winter Sleep",
                               rating: "PG",
                               total_gross: 318412101.00,
                               description: "If only Bergman were Turkish",
                               released_on: 6.months.ago }

  let!(:unrelased_movie) { Movie.create title: "The Salt of the Earth",
                                        rating: "PG-13",
                                        total_gross: 403706375.00,
                                        description: "Very compelling doc about life, love, loss, despair and redemption",
                                        released_on: 1.month.from_now }

  let!(:movie2) { Movie.create title: "Leviathan",
                               rating: "R",
                               total_gross: 134218018.00,
                               description: "Nowadays Tarkovsky in a Russian coastal town",
                               released_on: 4.months.ago }

  before { visit movies_url }

  it "shows the released movies" do
    expect(page).to have_text "2 Movies"
    expect(page).to have_text movie1.title
    expect(page).to have_text movie2.title

    expect(page).to have_text movie1.rating
    expect(page).to have_text movie1.description[0..9]
    expect(page).to have_text movie1.released_on
    expect(page).to have_text "$318,412,101.00"
  end

  it "does not show unreleased movies" do
    expect(page).not_to have_text unrelased_movie.title
  end

  it "allows navigation to the movie's detail page" do
    click_link movie2.title

    expect(current_path).to eq movie_path(movie2)
  end
end

require "rails_helper"

describe "Viewing the list of movies" do
  it "shows the movies" do
    movie1 = Movie.create title: "Winter Sleep",
                          rating: "PG",
                          total_gross: 318412101.00,
                          description: "If only Bergman were Turkish",
                          released_on: "2014-06-13"

    movie2 = Movie.create title: "Leviathan",
                          rating: "R",
                          total_gross: 134218018.00,
                          description: "Nowadays Tarkovsky in a Russian coastal town",
                          released_on: "2015-02-05"

    movie3 = Movie.create title: "The Salt of the Earth",
                          rating: "PG-13",
                          total_gross: 403706375.00,
                          description: "Very compelling doc about life, love, loss, despair and redemption",
                          released_on: "2015-03-27"

    visit movies_url

    expect(page).to have_text "3 Movies"
    expect(page).to have_text movie1.title
    expect(page).to have_text movie2.title
    expect(page).to have_text movie3.title

    expect(page).to have_text movie1.rating
    expect(page).to have_text movie1.description[0..9]
    expect(page).to have_text movie1.released_on
    expect(page).to have_text "$318,412,101.00"
  end
end

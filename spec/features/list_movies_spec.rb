require "rails_helper"

describe "Viewing the list of movies" do
  let!(:movie1) { Movie.create title: "Winter Sleep",
                               rating: "PG",
                               total_gross: 318412101.00,
                               description: "If only Bergman were Turkish",
                               released_on: 6.months.ago,
                               cast: "Haluk Bilginer, Melisa Sözen, Demet Akba",
                               director: "Nuri Bilge Ceylan",
                               duration: "196 min",
                               image_file_name: "wintersleep.jpg" }

  let!(:unrelased_movie) { Movie.create title: "The Salt of the Earth",
                                        rating: "PG-13",
                                        total_gross: 403706375.00,
                                        description: "Very compelling doc about life, love, loss, despair and redemption",
                                        released_on: 1.month.from_now,
                                        cast: "Sebastião Salgado, Wim Wenders, Juliano Ribeiro Salgado",
                                        director: "Wim Wender and Juliano Ribeiro Salgado",
                                        duration: "110 min",
                                        image_file_name: "saltearth.jpg" }

  let!(:movie2) { Movie.create title: "Leviathan",
                               rating: "R",
                               total_gross: 134218018.00,
                               description: "Nowadays Tarkovsky in a Russian coastal town",
                               released_on: 4.months.ago,
                               cast: "Aleksey Serebryakov, Elena Lyadova, Roman Madyanov",
                               director: " Andrey Zvyagintsev",
                               duration: "140 min",
                               image_file_name: "leviathan.jpg" }

  before { visit movies_url }

  it "shows the released movies" do
    expect(page).to have_text "Flix"
    expect(page).to have_text movie1.title
    expect(page).to have_text movie2.title

    expect(page).to have_text movie1.rating
    expect(page).to have_text movie1.description[0..9]
    expect(page).to have_text movie1.released_on.year
    expect(page).to have_text "$318,412,101.00"
    expect(page).to have_text movie1.cast
    expect(page).to have_text movie1.director
    expect(page).to have_text movie1.duration
    expect(page).to have_selector "img[src$='#{movie1.image_file_name}']"
  end

  it "does not show unreleased movies" do
    expect(page).not_to have_text unrelased_movie.title
  end

  it "allows navigation to the movie's detail page" do
    click_link movie2.title

    expect(current_path).to eq movie_path(movie2)
  end
end

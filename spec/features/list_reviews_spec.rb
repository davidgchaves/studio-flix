require 'rails_helper'
require 'support/attributes'

describe "Viewing a list of reviews" do
  it "shows the reviews for a specific movie" do
    iron_man = Movie.create movie_attributes(title: "Iron Man")
    roger_ebert = iron_man.reviews.create review_attributes(name: "Roger Ebert")
    gene_siskel = iron_man.reviews.create review_attributes(name: "Gene Siskel")

    superman = Movie.create movie_attributes(title: "Superman")
    peter_travers = superman.reviews.create review_attributes(name: "Peter Travers")

    visit movie_reviews_url iron_man

    expect(page).to have_text roger_ebert.name
    expect(page).to have_text gene_siskel.name
    expect(page).not_to have_text peter_travers.name
  end
end

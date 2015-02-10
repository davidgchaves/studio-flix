require 'rails_helper'
require 'support/attributes'

describe "Creating a new review for a movie" do
  let(:movie) { Movie.create movie_attributes }

  before do
    visit movie_url(movie)

    click_link "Write Review"
  end

  it "goes to the create review page" do
    expect(current_path).to eq new_movie_review_path(movie)
  end

  it "shows the form to create reviews" do
    expect(page).to have_text movie.title
    expect(page).to have_field "Name"
    expect(page).to have_field "Comment"
    expect(page).to have_field "Location"
    expect(page).to have_select "Stars"
    expect(page).to have_button "Post Review"
    expect(page).to have_link "Cancel"
  end
end

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

  context "on success" do
    before do
      fill_in "Name", with: "Roger Ebert"
      select 3, from: "Stars"
      fill_in "Comment", with: "I laughed, I cried, I spilled my popcorn!"
      fill_in "Location", with: "Chicago, IL"

      click_button "Post Review"
    end

    it "redirects to the listing reviews page for the movie" do
      expect(current_path).to eq movie_reviews_path(movie)
    end

    it "shows the new review's details" do
      expect(page).to have_text "Roger Ebert"
    end

    it "flashes a 'Thanks for your review!' message" do
      expect(page).to have_text "Thanks for your review!"
    end
  end

  context "on failure" do
    before do
      fill_in "Name", with: ""

      click_button "Post Review"
    end

    it "renders again the new template" do
      expect(current_path).to eq movie_reviews_path(movie)
      expect(page).to have_button "Post Review"
    end

    it "shows what was wrong last time" do
      expect(page).to have_text "correct the following"
    end
  end
end

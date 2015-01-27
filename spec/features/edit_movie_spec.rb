require "rails_helper"
require "support/attributes"

describe "Editing a movie" do
  let!(:movie) { Movie.create movie_attributes }

  before do
    visit movie_url(movie)
    click_link "Edit"
  end

  it "goes to the edit page" do
    expect(current_path).to eq edit_movie_path(movie)
  end

  it "shows the form to edit movies" do
    expect(find_field('Title').value).to eq movie.title
  end

  context "when done" do
    before do
      fill_in "Title" , with: "Updated Movie Title"
      click_button "Update Movie"
    end

    it "redirects to the detail page" do
      expect(current_path).to eq movie_path(movie)
    end

    it "shows the movie's updated details" do
      expect(page).to have_text "Updated Movie Title"
    end
  end
end

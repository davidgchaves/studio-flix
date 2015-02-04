require "rails_helper"

describe "Creating a new movie" do
  before do
    visit movies_url
    click_link "Add New Movie"
  end

  it "goes to the create page" do
    expect(current_path).to eq new_movie_path
  end

  it "shows the form to create movies" do
    expect(find_field("Title").value).to eq nil
    expect(find_field("Description").value).to eq ""
  end

  context "when done" do
    before do
      fill_in "Title", with: "New Movie Title"
      fill_in "Description", with: "Superheroes saving the world from villains"
      select "PG-13", from: "Rating"
      fill_in "Total gross", with: "75000000"
      fill_in "Cast", with: "The award-winning cast"
      fill_in "Director", with: "The ever-creative director"
      fill_in "Duration", with: "123 min"
      fill_in "Image file name", with: "movie.png"
      select (Time.now.year - 1).to_s, :from => "movie_released_on_1i"

      click_button "Create Movie"
    end

    it "redirects to the detail page" do
      expect(current_path).to eq movie_path(Movie.last)
    end

    it "shows the new movie's details" do
      expect(page).to have_text "New Movie Title"
    end
  end
end

require "rails_helper"

describe "Creating a new movie" do
  before(:example) do
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

  context "when on success" do
    before(:example) do
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

    it "flashes a 'movie successfully created' message" do
      expect(page).to have_text "Movie successfully created!"
    end
  end

  context "on failure" do
    before(:example) do
      fill_in "Title", with: ""
      fill_in "Description", with: "Superheroes saving the world from villains"

      click_button "Create Movie"
    end

    it "renders again the new template" do
      expect(current_path).to eq movies_path
      expect(page).to have_text "Create a New Movie"
    end

    it "shows info about what was wrong" do
      expect(page).to have_text "correct the following"
    end

    it "preserves the movie info previously entered" do
      expect(page).to have_text "Superheroes saving the world from villains"
    end
  end
end

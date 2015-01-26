require "rails_helper"

describe "Creating a new movie" do
  it "shows the form to create movies" do
    visit movies_url

    click_link "Add New Movie"

    expect(find_field("Title").value).to eq nil
    expect(find_field("Description").value).to eq ""
  end
end

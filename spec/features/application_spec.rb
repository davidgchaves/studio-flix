require "rails_helper"

describe "The flash" do
  it "is never shown with an empty message" do
    flash_types = %w[notice alert whatever]

    visit movies_url

    flash_types.each do |flash_type|
      expect(page).not_to have_css "p.flash.#{flash_type}"
    end
  end
end

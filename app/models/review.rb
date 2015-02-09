class Review < ActiveRecord::Base
  STARS = [1,2,3,4,5]

  belongs_to :movie

  validates :name, presence: true
  validates :comment, length: { minimum: 4 }
  validates :stars, inclusion: {
    in: STARS,
    message: "must be between 1 and 5" }
  validates :location, format: {
    with: /\A([A-Z]\S+),\s([A-Z]{2})\z/,
    message: "must be 'City, STATE' (with that casing)" }
end

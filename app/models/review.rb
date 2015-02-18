class Review < ActiveRecord::Base
  STARS = [1,2,3,4,5]

  belongs_to :movie

  validates_presence_of :name
  validates_length_of :comment, minimum: 4
  validates_inclusion_of :stars, in: STARS, message: "must be between 1 and 5"
  validates :location, format: {
    with: /\A([A-Z]\S+),\s([A-Z]{2})\z/,
    message: "must be 'City, STATE' (with that casing)" }
end

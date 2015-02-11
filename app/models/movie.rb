class Movie < ActiveRecord::Base
  has_many :reviews, dependent: :destroy

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, inclusion: { in: RATINGS }
  validates :image_file_name, allow_blank: true, format: {
    with: /\w+\.(jpg|png|gif)\z/i,
    message: "must reference a GIF, JPG or PNG image" }

  def flop?
    total_gross.blank? || total_gross < 50000000.00
  end

  def cult_classic?
    reviews.size > 50 && average_stars >= 4
  end

  def self.released
    where("released_on <= ?", Time.now).order released_on: :desc
  end

  def self.hits
    where("total_gross >= ?", 300000000).order total_gross: :desc
  end

  def self.flops
    where("total_gross < ?", 50000000).order total_gross: :asc
  end

  def self.recently_added
    order(created_at: :desc).limit 3
  end

  def average_stars
    reviews.average :stars
  end

  def recent_reviews
    reviews.order(created_at: :desc).limit 2
  end
end

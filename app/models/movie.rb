class Movie < ActiveRecord::Base
  has_many :reviews, dependent: :destroy

  RATINGS = %w(G PG PG-13 R NC-17)

  validates_presence_of :title, :released_on, :duration
  validates_length_of :description, minimum: 25
  validates_numericality_of :total_gross, greater_than_or_equal_to: 0
  validates_inclusion_of :rating, in: RATINGS
  validates_format_of :image_file_name, allow_blank: true,
    with: /\w+\.(jpg|png|gif)\z/i,
    message: "must reference a GIF, JPG or PNG image"

  scope :flops, -> { where("total_gross < ?", 50000000).order total_gross: :asc }
  scope :hits, -> { where("total_gross >= ?", 300000000).order total_gross: :desc }
  scope :released, -> { where("released_on <= ?", Time.now).order released_on: :desc }
  scope :recently_added, -> { order(created_at: :desc).limit 3 }

  def flop?
    !cult_classic? && (total_gross.blank? || total_gross < 50000000.00)
  end

  def cult_classic?
    reviews.size > 50 && average_stars >= 4
  end

  def average_stars
    reviews.average :stars
  end

  def recent_reviews
    reviews.order(created_at: :desc).limit 2
  end
end

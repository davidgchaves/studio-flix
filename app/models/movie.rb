class Movie < ActiveRecord::Base
  def flop?
    total_gross.blank? || total_gross < 50000000.00
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
end

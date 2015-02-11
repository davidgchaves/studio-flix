module MoviesHelper
  def format_total_gross(movie)
    movie.flop? ? content_tag(:strong, "Flop!") : number_to_currency(movie.total_gross)
  end

  def format_average_stars(movie)
    if movie.reviews.empty?
      content_tag :strong, "No Reviews"
    else
      pluralize number_with_precision(movie.average_stars, precision: 1), "star"
    end
  end

  def format_recent_reviews(movie)
    render('layouts/recent_reviews_section') if movie.recent_reviews.any?
  end

  def image_for(movie)
    movie.image_file_name.blank? ? image_tag("placeholder.png") : image_tag(movie.image_file_name)
  end
end

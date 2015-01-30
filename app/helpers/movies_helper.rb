module MoviesHelper
  def format_total_gross(movie)
    movie.flop? ? content_tag(:strong, "Flop!") : number_to_currency(movie.total_gross)
  end

  def image_for(movie)
    movie.image_file_name.blank? ? image_tag("placeholder.png") : image_tag(movie.image_file_name)
  end
end

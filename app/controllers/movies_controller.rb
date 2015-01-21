class MoviesController < ApplicationController
  def index
    @movies = ["Winter Sleep", "Leviathan", "The Salt of the Earth"]
  end
end

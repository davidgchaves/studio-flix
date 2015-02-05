class MoviesController < ApplicationController
  def index
    @movies = Movie.released
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new movie_params
    if @movie.save
      redirect_to @movie
    else
      render :new
    end
  end

  def show
    @movie = Movie.find params[:id]
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update movie_params
    redirect_to @movie
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    redirect_to movies_url
  end

  private
    def movie_params
      params.require(:movie).
             permit(:title, :description, :rating, :released_on, :total_gross,
                    :director, :cast, :duration, :image_file_name)
    end
end

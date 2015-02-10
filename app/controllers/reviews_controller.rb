class ReviewsController < ApplicationController
  def index
    @movie = Movie.find params[:movie_id]
    @reviews = @movie.reviews
  end

  def new
    @movie = Movie.find params[:movie_id]
    @review = @movie.reviews.new
  end

  def create
    @movie = Movie.find params[:movie_id]
    @review = @movie.reviews.create review_params
    redirect_to movie_reviews_path(@movie), notice: "Thanks for your review!"
  end

  private
    def review_params
      params.require(:review).permit :name, :stars, :comment, :location
    end
end
